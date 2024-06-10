//
//  ContentView.swift
//  Amin
//
//  Created by Calin Gavriliu on 04.06.2024.
//

import SwiftUI

let openAIKey = "ha nice try"

struct ContentView: View {
    
    @State var chatMessages: [ChatMessage]
    
    @State var message = ""
    @State var showSendButton = false
    
    @ObservedObject var openAIService = OpenAIService()
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView {
                VStack(spacing: 18) {
                    ForEach(chatMessages) { message in
                        HStack {
                            if message.sender == .user { Spacer(minLength: 80) }
                            
                            Text(message.content)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .foregroundColor(message.sender == .user ? .white : .black)
                                .background(message.sender == .user ? .blue : Color(.systemGray6))
                                .cornerRadius(12)
                            
                            if message.sender == .gpt { Spacer(minLength: 80) }
                        }
                    }
                    
                    if openAIService.isLoading && !openAIService.isInitialLoading {
                        HStack {
                            ProgressView()
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            Spacer(minLength: 80)
                        }
                    }
                    
                    Color(.systemBackground)
                        .opacity(0)
                        .frame(height: 32)
                        .padding()
                }
                .padding()
            }
            .defaultScrollAnchor(.bottom)
            
            VStack {
                Spacer()
                HStack {
                    TextField("Scrie un mesaj...", text: $message)
                        .padding(.horizontal, 16)
                        .frame(height: 45)
                        .background(Color(.systemBackground))
                        .background(.ultraThickMaterial)
                        .cornerRadius(12)
                    if showSendButton {
                        Button(action: {
                            let messageSentToGPT = message
                            withAnimation {
                                chatMessages.append(ChatMessage(id: UUID().uuidString, content: message, dateCreated: Date(), sender: .user))
                            }
                            message = ""
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                openAIService.sendMessage(message: messageSentToGPT)
                            }
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .frame(width: 42, height: 42)
                                .background(Color.black)
                                .cornerRadius(12)
                                .background(.ultraThickMaterial)
                        }
                    }
                }
                .padding()
                .background(.thickMaterial)
            }
            
            if let errorMessage = openAIService.errorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//                    .padding()
                //
            }
            
            VStack {
                Color(.systemBackground)
                    .frame(height: safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.all)
                
                Spacer()
            }
        }
        .onAppear { openAIService.initialize() }
        .onReceive(openAIService.$responseMessage) { response in
            if !response.isEmpty {
                withAnimation {
                    chatMessages.append(ChatMessage(id: UUID().uuidString, content: response, dateCreated: Date(), sender: .gpt))
                }
            }
        }
        .onChange(of: message) {
            withAnimation(.easeOut(duration: 0.32)) {
                if message != "" {
                    showSendButton = true
                } else {
                    showSendButton = false
                }
            }
        }
    }
}

struct ChatMessage: Identifiable {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case user
    case gpt
}

extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Mesaj 1", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Raspuns 1 mai luuuung", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Mesaj 2 mai lung foarte lung foarte lung foarte lung foarte lung foarte lung", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Raspuns 2", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Raspuns 1 mai luuuung", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Raspuns 1 mai luuuung", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Raspuns 1 mai luuuung", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Raspuns 1 mai luuuung", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Mesaj 2 mai lung foarte lung foarte lung foarte lung foarte lung foarte lung", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Raspuns 1 mai luuuung", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Mesaj 2 mai lung foarte lung foarte lung foarte lung foarte lung foarte lung", dateCreated: Date(), sender: .user),
    ]
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        let safeAreaInsets = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first?
            .safeAreaInsets ?? UIEdgeInsets()
        
        return EdgeInsets(
            top: safeAreaInsets.top,
            leading: safeAreaInsets.left,
            bottom: safeAreaInsets.bottom,
            trailing: safeAreaInsets.right
        )
    }
}

#Preview {
    ContentView(chatMessages: ChatMessage.sampleMessages)
}
