//
//  SampleMessages.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import Foundation

extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Salut! Sunt aici sa te ajut.", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Buna. Da-mi niste sfaturi pentru Time Management.", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: """
        Sigur, Calin! Time management-ul este esențial pentru a-ți menține echilibrul și a te simți bine.
        Iată câteva sfaturi care ar putea să te ajute:
        @TITLE@
        ***Sfaturi pentru Time Management***
        @LIST@
        1. **Prioritizează-ți sarcinile** - Folosește matricea Eisenhower pentru a decide ce este urgent și important.
        2. **Setează obiective clare** - Definește-ți obiective specifice, măsurabile, realizabile, relevante și limitate în timp (SMART).
        3. **Folosește un calendar sau o agendă** - Planifică-ți ziua în avans și alocă timp pentru fiecare activitate.
        4. **Folosește AAAAAAAAAA** - Planifică-ți ziua în avans și alocă timp pentru fiecare activitate doar ca textul asta e diferit.
        5. **TITLU gyuefhjfeciuh** - hubjefdkiugfvbjwdknshugyhvbenw msdjkuhbjfnd scmjkxhjbefdn msjhe
        6. **hbjeasfhuefhuwefhu* - uyteqrgjtugjhfdahjgfvgyvfuwbhjgskhjbkjesghkegruhjkdergjhgrdvefhdjrefghdfgrvhjbfdbhjgdfvhjbdfrvhdfrvyfr
        @LIST@
        Alte informații care nu trebuie incluse.
        """, dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "poftim", dateCreated: Date(), sender: .gpt)
    ]
}
