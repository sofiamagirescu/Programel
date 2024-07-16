//
//  ChatMessageModel.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import Foundation

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
