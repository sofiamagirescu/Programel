//
//  OpenAIService.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 10.06.2024.
//

import SwiftUI
import Combine
import Alamofire


let userFirstName = "Calin"
let userPronouns = "masculine"



// TOKENS LIMIT DE STABILIT

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
            sendMessage(message: initialPrompt, shouldTrackResponse: true)
            isInitialized = true
        }
    }
    
    
    
    
    
    func sendMessage(message: String, shouldTrackResponse: Bool = true, retryCount: Int = 3, isSummary: Bool = false) {
        let userMessage = ["role": "user", "content": message]
        conversationHistory.append(userMessage)
        
        
        let body = OpenAICompletionsBody(model: "gpt-4o", messages: conversationHistory, temperature: 0.5, max_tokens: 256)
//        let body = OpenAICompletionsBody(model: "gpt-3.5-turbo", messages: conversationHistory, temperature: 0.5, max_tokens: 256)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openAIKey)"
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
            .timeout(.seconds(10), scheduler: DispatchQueue.main)
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
                if let value = response.value, let content = value.choices.first?.message.content {
                    if shouldTrackResponse {
                        if isSummary {
                            self.summaryMessage = content
                        } else {
                            self.responseMessage = content
                            let assistantMessage = ["role": "assistant", "content": content]
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
//        let summaryPrompt = "Summarize the following conversation:\n\n" + conversationHistory.map { "\($0["role"]!): \($0["content"]!)" }.joined(separator: "\n")
        
        let summaryPrompt = "SISTEM: Genereaza un rezumat scurt al conversatiei, ce surprinde infomatiile esentiale. Este scris la persoana intai, sub forma unei pagini de jurnal (monolog, nu voberste cu jurnalul). Limbajul sa NU fie robotic, ci fluid, uman si firesc. NU inventa nimic. Daca s-a discutat nimic, spui asta."
        sendMessage(message: summaryPrompt, shouldTrackResponse: true, isSummary: true)
    }
}


//class OpenAIService: ObservableObject {
//    let baseURL = "https://api.openai.com/v1/chat/completions"
//    @Published var responseMessage: String = ""
//    var conversationHistory: [[String: String]] = []
//    
//    func sendMessage(message: String) {
//        let userMessage = ["role": "user", "content": message]
//        conversationHistory.append(userMessage)
//        
//        let body = OpenAICompletionsBody(model: "gpt-3.5-turbo", messages: conversationHistory, temperature: 0.5, max_tokens: 256)
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(openAIKey)"
//        ]
//        AF.request(baseURL, method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAIResponse.self) { response in
//            switch response.result {
//            case .success(let value):
//                if let content = value.choices.first?.message.content {
//                    self.responseMessage = content
//                    let assistantMessage = ["role": "assistant", "content": content]
//                    self.conversationHistory.append(assistantMessage)
//                }
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//    }
//}



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
