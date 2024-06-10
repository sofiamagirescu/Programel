//
//  OpenAIService.swift
//  Amin
//
//  Created by Calin Gavriliu on 10.06.2024.
//

import SwiftUI
import Combine
import Alamofire

class OpenAIService: ObservableObject {
    let baseURL = "https://api.openai.com/v1/chat/completions"
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isInitialLoading: Bool = true
    var conversationHistory: [[String: String]] = []
    private var cancellables = Set<AnyCancellable>()
    private var isInitialized = false
    
    func initialize() {
        if !isInitialized {
            let initialPrompt = "You are a digital assistant that helps people better understand their feelings."
            sendMessage(message: initialPrompt, shouldTrackResponse: false)
            isInitialized = true
        }
    }
    
    func sendMessage(message: String, shouldTrackResponse: Bool = true) {
        let userMessage = ["role": "user", "content": message]
        conversationHistory.append(userMessage)
        
        let body = OpenAICompletionsBody(model: "gpt-3.5-turbo", messages: conversationHistory, temperature: 0.5, max_tokens: 256)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(openAIKey)"
        ]
        
        isLoading = true
        errorMessage = nil
        AF.request(baseURL, method: .post, parameters: body, encoder: .json, headers: headers)
            .validate()
            .publishDecodable(type: OpenAIResponse.self)
            .timeout(.seconds(10), scheduler: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                self.isInitialLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                self.isLoading = false
                self.isInitialLoading = false
                if let value = response.value, let content = value.choices.first?.message.content {
                    if shouldTrackResponse {
                        self.responseMessage = content
                    }
                    let assistantMessage = ["role": "assistant", "content": content]
                    self.conversationHistory.append(assistantMessage)
                } else if let error = response.error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            })
            .store(in: &self.cancellables)
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
