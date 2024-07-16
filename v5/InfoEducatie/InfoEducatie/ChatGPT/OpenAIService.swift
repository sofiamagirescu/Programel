//
//  OpenAIService.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 10.06.2024.
//

import SwiftUI
import Combine
import Alamofire


// STILIZAREA TEXTULUI BOLD CU **

// POST-ITs SI SFATURI CURATED DE PSIHOLOGI + CONTENT ORIGINAL



class OpenAIService: ObservableObject {
    let baseURL = "https://api.openai.com/v1/chat/completions"
    
    @Published var responseMessage: String = ""
    @Published var errorMessage: String? = nil
    
    @Published var summaryMessage: String = ""
    @Published var isSummaryLoading: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var isInitialLoading: Bool = true
    private var isInitialized = false
    
    var conversationHistory: [[String: String]] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
    func initialize(initialPrompt: String) {
        if !isInitialized {
            sendMessage(message: "\(initialPrompt) Incearca sa nu depasesti 512 tokenuri. Inainte de a genera o lista, scrie '@TITLE@', apoi ofera un titlu listei, inconjurat de trei stelute (*). Sub titlu scrie '@LIST@'. Dupa ce termini de generat itemii listei, scrie, din nou '@LIST@'. Fiecare item sa fie de forma: '1. **Titlu 1** - Corp 1'. ETICHETAREA IN ACEST FEL ESTE ESENTIALA SI TREBUIE FACUTA CHIAR SI PENTRU LISTE CU UN SINGUR ITEM. Nu include intrebari in itemii listei. Genereaza o singura lista pentru fiecare mesaj. Orice sfat / recomandare este generat sub forma unei liste. Daca utilizatorul iti cere itemi suplimentari la o lista deja existenta, foloseste ACELASI titlu (NU SCHIMBA NICI MACAR O LITERA DIN TITLU) si incepe cu urmatorul index (ex: daca lista deja existenta are 7 itemi, primul articol din lista noua cu acelasi subiect va avea indexul 8). Ai voie sa generezi liste doar cand dai sfaturi sau lucruri care ar trebui sa fie memorate de catre utilizator. Aceste reguli sunt necesare pentru functionarea programului. Nu ai voie sa te abati de la ele. Abaterea este strict interzisa. Abaterea inseamna moarte. te pup", shouldTrackResponse: true)
            isInitialized = true
        }
    }
    
    func sendMessage(message: String, shouldTrackResponse: Bool = true, retryCount: Int = 3, isSummary: Bool = false) {
        let userMessage = ["role": "user", "content": message]
        conversationHistory.append(userMessage)
        
        
        let body = OpenAICompletionsBody(model: "gpt-4o", messages: conversationHistory, temperature: 0.5, max_tokens: 2048)
//        let body = OpenAICompletionsBody(model: "gpt-3.5-turbo", messages: conversationHistory, temperature: 0.5, max_tokens: 256)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Keys().openAIKey)"
        ]
        
        if isSummary {
            isSummaryLoading = true
        } else {
            isLoading = true
        }
        errorMessage = nil
        
        AF.request(baseURL, method: .post, parameters: body, encoder: .json, headers: headers)
            .validate()
            .publishDecodable(type: OpenAIResponse.self)
            .timeout(.seconds(20), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if isSummary {
                    self.isSummaryLoading = false
                } else {
                    self.isLoading = false
                }
                self.isInitialLoading = false
                
                // SE AFISEAZA EROAREA DACA E CAZUL
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    if retryCount > 0 {
                        print("Retrying... \(retryCount) attempts left.")
                        self.sendMessage(message: message, shouldTrackResponse: shouldTrackResponse, retryCount: retryCount - 1, isSummary: isSummary)
                    } else {
                        if !self.isInitialized {
                            self.responseMessage = "I'm sorry, but I'm currently unable to provide a response. Please try again later."
                        }
                        self.errorMessage = "Error: \(error.localizedDescription)"
                    }
                }
            }, receiveValue: { response in
                if isSummary {
                    self.isSummaryLoading = false
                } else {
                    self.isLoading = false
                }
                self.isInitialLoading = false
//                if let value = response.value, let content = value.choices.first?.message.content {
//                    if shouldTrackResponse {
//                        if isSummary {
//                            self.summaryMessage = content
//                        } else {
//                            self.responseMessage = content
//                            let assistantMessage = ["role": "assistant", "content": content]
//                            self.conversationHistory.append(assistantMessage)
//                        }
//                    }
//                } 
                if let value = response.value, let content = value.choices.first?.message.content {
                    let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    if shouldTrackResponse {
                        if isSummary {
                            self.summaryMessage = trimmedContent
                        } else {
                            self.responseMessage = trimmedContent
                            let assistantMessage = ["role": "assistant", "content": trimmedContent]
                            self.conversationHistory.append(assistantMessage)
                        }
                    }
                }
                
                // SE AFISEAZA EROAREA DACA E CAZUL
                else if let error = response.error {
                    if !self.isInitialized {
                        self.responseMessage = "I'm sorry, but I'm currently unable to provide a response. Please try again later."
                    }
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            })
            .store(in: &self.cancellables)
    }
    
    func summarizeConversation() {
        let summaryPrompt = "SISTEM: Genereaza un rezumat scurt al conversatiei, ce surprinde infomatiile esentiale. Este scris la persoana intai, sub forma unei pagini de jurnal (monolog, nu voberste cu jurnalul). Limbajul sa NU fie robotic, ci fluid, uman si firesc. NU inventa nimic. Daca s-a discutat nimic, spui asta. Limita de tokenuri este, acum, 2000."
        sendMessage(message: summaryPrompt, shouldTrackResponse: true, isSummary: true)
        
        // PENTRU A TESTA
//        sendMessage(message: "Do nothing", shouldTrackResponse: true, isSummary: true)
    }
}



struct OpenAICompletionsBody: Encodable {
    let model: String
    let messages: [[String: String]]
    let temperature: Float?
    let max_tokens: Int?
}

struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
