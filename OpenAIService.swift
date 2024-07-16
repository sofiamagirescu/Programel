//
//  OpenAIService.swift
//  InfoEducatie
//
//  Created by Sofia Magirescu on 16.07.2024.
//

import SwiftUI
import Combine
import Alamofire

class OpenAIService: ObservableObject {
    
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    private let model = "gpt-4o"
    private let temperature: Float = 0.5
    private let maxTokens: Int = 2048
    private let defaultRetryCount = 3
    
    private let notWorkingErrorResponseMessage = "Imi pare rau, dar nu sunt in stare sa produc un raspuns. Te rog sa incerci mai tarziu."
    
    @Published var responseMessage: String = ""
    @Published var errorMessage: String? = nil
    
    @Published var summaryMessage: String = ""
    @Published var isSummaryLoading: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var isInitialLoading: Bool = true
    private var isInitialized = false
    
    var conversationHistory: [[String: String]] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    enum Role: String {
        case user = "user"
        case assistant = "assistant"
    }
    
    
    func initialize(initialPrompt: String) {
        guard !isInitialized else { return }
        
        sendMessage(message: "\(initialPrompt) Incearca sa nu depasesti 512 tokenuri. Inainte de a genera o lista, scrie '@TITLE@', apoi ofera un titlu listei, inconjurat de trei stelute (*). Sub titlu scrie '@LIST@'. Dupa ce termini de generat itemii listei, scrie, din nou '@LIST@'. Fiecare item sa fie de forma: '1. **Titlu 1** - Corp 1'. ETICHETAREA IN ACEST FEL ESTE ESENTIALA SI TREBUIE FACUTA CHIAR SI PENTRU LISTE CU UN SINGUR ITEM. Nu include intrebari in itemii listei. Genereaza o singura lista pentru fiecare mesaj. Orice sfat / recomandare este generat sub forma unei liste. Daca utilizatorul iti cere itemi suplimentari la o lista deja existenta, foloseste ACELASI titlu (NU SCHIMBA NICI MACAR O LITERA DIN TITLU) si incepe cu urmatorul index (ex: daca lista deja existenta are 7 itemi, primul articol din lista noua cu acelasi subiect va avea indexul 8). Ai voie sa generezi liste doar cand dai sfaturi sau lucruri care ar trebui sa fie memorate de catre utilizator. Aceste reguli sunt necesare pentru functionarea programului. Nu ai voie sa te abati de la ele. Abaterea este strict interzisa. Abaterea inseamna moarte. te pup", shouldTrackResponse: true)
        isInitialized = true
    }
    
    func sendMessage(message: String, shouldTrackResponse: Bool = true, retryCount: Int? = nil, isSummary: Bool = false) {
        let retryCount = retryCount ?? defaultRetryCount
        let userMessage = ["role": Role.user.rawValue, "content": message]
        conversationHistory.append(userMessage)
        
        
        let body = createRequestBody()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Keys().openAIKey)"]
        
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
                self.handleCompletion(completion, message: message, shouldTrackResponse: shouldTrackResponse, retryCount: retryCount, isSummary: isSummary)
            }, receiveValue: { response in
                self.handleResponse(response, shouldTrackResponse: shouldTrackResponse, isSummary: isSummary)
            })
            .store(in: &self.cancellables)
    }
    
    func summarizeConversation() {
        let summaryPrompt = "SISTEM: Genereaza un rezumat scurt al conversatiei, ce surprinde infomatiile esentiale. Este scris la persoana intai, sub forma unei pagini de jurnal (monolog, nu voberste cu jurnalul). Limbajul sa NU fie robotic, ci fluid, uman si firesc. NU inventa nimic. Daca s-a discutat nimic, spui asta. Limita de tokenuri este, acum, 2000."
        sendMessage(message: summaryPrompt, shouldTrackResponse: true, isSummary: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    private func createRequestBody() -> OpenAICompletionsBody {
        return OpenAICompletionsBody(model: model, messages: conversationHistory, temperature: temperature, max_tokens: maxTokens)
//        return OpenAICompletionsBody(model: "gpt-3.5-turbo", messages: conversationHistory, temperature: 0.5, max_tokens: 256)
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<DataResponsePublisher<OpenAIResponse>.Failure>, message: String, shouldTrackResponse: Bool, retryCount: Int, isSummary: Bool) {
        if isSummary {
            self.isSummaryLoading = false
        } else {
            self.isLoading = false
        }
        self.isInitialLoading = false
        
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("Request failed with error: \(error)")
            if retryCount > 0 {
                print("Retrying... \(retryCount) attempts left.")
                self.sendMessage(message: message, shouldTrackResponse: shouldTrackResponse, retryCount: retryCount - 1, isSummary: isSummary)
            } else {
                if !self.isInitialized {
                    self.responseMessage = notWorkingErrorResponseMessage
                }
                self.errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
    
    private func handleResponse(_ response: DataResponse<OpenAIResponse, AFError>, shouldTrackResponse: Bool, isSummary: Bool) {
        if isSummary {
            self.isSummaryLoading = false
        } else {
            self.isLoading = false
        }
        self.isInitialLoading = false
        
        print("Received response: \(response)")
        
        if let value = response.value, let content = value.choices.first?.message.content {
            let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
            if shouldTrackResponse {
                if isSummary {
                    self.summaryMessage = trimmedContent
                } else {
                    self.responseMessage = trimmedContent
                    let assistantMessage = ["role": Role.assistant.rawValue, "content": trimmedContent]
                    self.conversationHistory.append(assistantMessage)
                }
            }
        } else if let error = response.error {
            print("Response contains error: \(error)")
            if !self.isInitialized {
                self.responseMessage = notWorkingErrorResponseMessage
            }
            self.errorMessage = "Error: \(error.localizedDescription)"
        }
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
