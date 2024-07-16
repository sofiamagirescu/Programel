//
//  ChatView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 17.06.2024.
//

import SwiftUI
import Combine

struct ChatView: View {
    
    @EnvironmentObject var openAIService: OpenAIService
    
    @State var chatMessages: [ChatMessage]
//    @Binding var emotion: CurrentEmotion
//    @Binding var causes: [Cause]
    
    @Binding var organizedSelectedTips: [String: [Tip]]
    
    @State private var load = false
    @State private var showQuizScalePicker = false
    
    @State private var message = ""
    @State private var showSendButton = false
    
    var prompt: String {
//        "SISTEM: Esti un asistent personal pentru utilizator. Numele utilizatorului este \(UserInfo().userFirstName) \(UserInfo().userFirstName) (mai intai prenumele, apoi numele de familie) si foloseste pronume \(UserInfo().userPronouns). In momentul de fata, se simte \(emotion.name.lowercased()), datorita \(causes.map { $0.name }.joined(separator: " + ").lowercased()). Scopul tău este sa îl faci sa-si inteleaga mai bine sentimentele, sa proceseze cum au contribuit cauzele mentionate mai sus + evenimentele de astăzi la starea lui actuala si să-i dai sfaturi / soluții. Ofera-i intrebari scurte, care il indruma spre directia cea buna si cuvinte de incurajare din cand in cand, la fel, scurte, dar calde. Daca utilizatorul intreaba ceva ce nu e deloc legat de dezvoltare personala, refuza sa-i raspunzi politicos. Ai voie sa te abati de la subiect daca iti cere sfaturi, conditia fiind sa revii imediat. Vorbeste pe un ton cald, semi-haios si intelegator, ca si cum esti prietenul lui si asigura-te ca nu se simte judecat. Conversatia sa fie fluida si daca nu schimba utilizatorul subiectul pentru mult timp, atunci schimba-l tu. \(UserInfo().userFirstName) a completat deja un chestionar, unde si-a specificat starea si ce a cauzat-o vag (vezi mai sus), deci poti sa incepi direct cu esenta. Initiaza conversatia printr-un mesaj scurt si la subiect, fara a face referire la aceste instructiuni. Incearca sa nu pui intrebari extrem de generale dupa primele cateva mesaje. Nu presupune nimic (de exemplu, daca apare mai sus ca utilizatorul se simte prost nu-l intreba de ce e complesit, intreaba-l de ce se simte prost si atat, sau, daca scrie mai sus de fitness, nu il intreba de antrenament, MAI PUTIN CAND SPECIFICA UTILIZATORUL INSUSI). "
        ""
    }
    
    var body: some View {
        GeometryReader { geometry in
            let shouldBeGrid = geometry.size.width > MaxWidths().shouldTipsBeGrid
            
            ScrollViewReader { proxy in
                VStack(spacing: 16) {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 12) {
                                Color.red.opacity(0).frame(width: 1, height: 6)
                                
                                Text("In sfarsit...")
                                
                                Text("Haide sa aprofundam!")
                                    .font(.custom("DMSerifDisplay-Regular", size: 36))
                                
                                Divider()
                                    .padding(.vertical, 18)
                            }
                            .foregroundColor(.primary)
                            .frame(maxWidth: MaxWidths().maxStandardWidth)
                            
                            VStack(spacing: 14) {
                                ForEach(chatMessages) { message in
                                    VStack(alignment: .leading, spacing: 24) {
                                        HStack {
                                            if message.sender == .user { Spacer(minLength: 80) }
                                            
                                            if trimExtraNewlines(from: message.content.components(separatedBy: "@TITLE@")[0]) != "" {
                                                Text(trimExtraNewlines(from: message.content.components(separatedBy: "@TITLE@")[0]))
                                                    .chatMessageStyle(accentColor: Color("Bine"), isUser: message.sender == .user)
                                                
                                                if message.sender == .gpt { Spacer(minLength: 80) }
                                            }
                                        }
                                        
                                        if message.sender == .gpt && message.content.contains("@LIST@") {
                                            
                                            HStack {
                                                Spacer(minLength: 0)
                                                
                                                CardTipsView(
                                                    tips: extractTips(from: message.content),
                                                    title: extractTitle(from: message.content),
                                                    organizedSelectedTips: $organizedSelectedTips,
                                                    shouldBeGrid: shouldBeGrid,
                                                    showIndexByPosition: true
                                                )
                                                .padding(.top, 8)
                                                .padding(.bottom, 14)
                                                
                                                Spacer(minLength: 0)
                                            }
                                            
                                            if trimExtraNewlines(from: message.content.components(separatedBy: "@LIST@")[2]) != "" {
                                                HStack {
                                                    Text(trimExtraNewlines(from: message.content.components(separatedBy: "@LIST@")[2]))
                                                        .chatMessageStyle(accentColor: Color("Bine"), isUser: message.sender == .user)
                                                    Spacer(minLength: 80)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
//                            if showQuizScalePicker {
                            if true {
                                
                                Divider()
                                    .padding(.vertical, 18)
                                
                                HStack {
                                    Text("Acum ca am terminat de discutat despre situatia zilei, e timpul de un quiz ez plangi haha")
                                        .chatMessageStyle(accentColor: Color("Bine"), isUser: false)
                                    Spacer(minLength: 80)
                                }
                                .padding(.bottom, 6)
                                
                                ForEach(Array(quizQuestions.enumerated()), id: \.element.id) { index, question in
                                    VStack(spacing: 18) {
                                        Text("Intrebarea \(index + 1) / 6")
                                            .font(.subheadline)
                                            .opacity(0.36)
                                        HStack {
                                            Text("\(question.question)\n(pe o scara de la 1 la 10)")
                                                .chatMessageStyle(accentColor: Color("Bine"), isUser: false)
                                            Spacer(minLength: 80)
                                        }
                                    }
                                    
                                    HStack {
                                        Spacer(minLength: 80)
                                        Text("\(Int.random(in: 1...10))")
                                            .fontWeight(.medium)
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(Color(.systemBackground))
                                            .background(Color("Bine"))
                                            .clipShape(Circle())
                                            .shadow(color: .black.opacity(0.03), radius: 4, x: 2, y: 4)
//                                            .shadow(color: Color("Bine").opacity(0.07), radius: 8, x: 2, y: 4)
                                    }
                                }
                            }
                            
                            Color.red.opacity(0).frame(width: 1, height: 3)
                        }
                        .id("Bottom")
                    }
                    .mask(
                        VStack(spacing: 0) {
                            LinearGradient(colors: [.red.opacity(0), .red], startPoint: .top, endPoint: .bottom).frame(height: 6)
                            Color.red
                            LinearGradient(colors: [.red.opacity(0), .red], startPoint: .bottom, endPoint: .top).frame(height: 6)
                        }
                    )
                    .shadow(color: Color.black.opacity(0.02), radius: 6, x: 4, y: 8)
                    
                    Button(action: {
                        withAnimation(.smooth(duration: 0.2)) {
                            showQuizScalePicker.toggle()
                        }
                    }) {
                        Text("Schimba")
                    }
                    
                    ZStack(alignment: .bottomTrailing) {
                        if showQuizScalePicker {
                            
                            ScrollViewReader { secondProxy in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(0..<10) { i in
                                            Text("\(i + 1)")
                                                .fontWeight(.medium)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.primary)
                                                .background(Color(.systemBackground))
                                                .clipShape(Circle())
                                                .shadow(color: .black.opacity(0.03), radius: 4, x: 2, y: 4)
                                                .shadow(color: Color("Bine").opacity(0.07), radius: 8, x: 2, y: 4)
                                                .id("Optiunea \(i + 1)")
                                        }
                                    }
                                }
                                .scrollClipDisabled()
                                .padding(.horizontal, -32)
                                .safeAreaPadding(.horizontal, 32)
                                .mask(
                                    HStack(spacing: 0) {
                                        Color.red.opacity(0).frame(width: 8)
                                        LinearGradient(colors: [.red.opacity(0), .red], startPoint: .leading, endPoint: .trailing).frame(width: 16)
                                        Color.red
                                        LinearGradient(colors: [.red.opacity(0), .red], startPoint: .trailing, endPoint: .leading).frame(width: 16)
                                        Color.red.opacity(0).frame(width: 8)
                                    }
                                    .padding(-32)
                                )
                                .onAppear {
                                    withAnimation {
                                        secondProxy.scrollTo("Optiunea 5", anchor: .center)
                                    }
                                }
                            }
                            
                        } else {
                            HStack(spacing: 12) {
                                if openAIService.isLoading || load {
                                    ProgressView()
                                }
                                
                                TextField(openAIService.isLoading || load ? "Stevie se gandeste" : "Scrie un mesaj...", text: $message, axis: .vertical)
                                    .tint(.secondary)
                                    .disabled(openAIService.isLoading || load)
                                
                                Spacer(minLength: 0)
                            }
                            .padding(.leading, 16)
                            .padding(.trailing, 58)
                            .padding(.vertical, 12)
                            .lineLimit(1...12)
                            .frame(minHeight: 50)
                            .foregroundColor(.primary)
                            .background(Color.white.blendMode(.overlay))
                            .cornerRadius(12)
                            .animation(.smooth(duration: 0.2), value: openAIService.isLoading || load)
                            
                            
                            Button(action: {
                                let messageSentToGPT = message
                                DispatchQueue.main.async {
                                    withAnimation {
                                        chatMessages.append(ChatMessage(id: UUID().uuidString, content: message, dateCreated: Date(), sender: .user))
                                        chatMessages.append(ChatMessage(id: UUID().uuidString, content: "raspunsul vine aiciiii", dateCreated: Date(), sender: .gpt))
                                        message = ""
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                                            withAnimation {
                                                proxy.scrollTo("Bottom", anchor: .bottom)
                                            }
                                        }
                                    }
                                }
//                                openAIService.sendMessage(message: messageSentToGPT)
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                    .frame(width: 38, height: 38)
                                    .background(Color.black)
                                    .cornerRadius(12)
                                    .rotationEffect(.degrees(90))
                            }
                            .staggeredAppear(isVisible: showSendButton && !openAIService.isLoading, index: 0, offset: 3, duration: 0.24)
                            .rotationEffect(.degrees(-90))
                            .padding(6)
                        }
                    }
                    .frame(maxWidth: MaxWidths().maxStandardWidth)
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                hideKeyboard()
                            }
                    )
                }
                .onAppear {
//                    openAIService.initialize(initialPrompt: prompt)
//                    openAIService.sendMessage(message: "SISTEM: Incepe o conversatie in limba romana cu utilizatorl.")
                    
                    // DOAR PT TESTARE
                    withAnimation {
                        proxy.scrollTo("Bottom", anchor: .bottom)
                    }
                }
                .onReceive(openAIService.$responseMessage) { response in
                    if !response.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                            withAnimation {
                                chatMessages.append(ChatMessage(id: UUID().uuidString, content: response, dateCreated: Date(), sender: .gpt))
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                proxy.scrollTo("Bottom", anchor: .bottom)
                            }
                        }
                    }
                }
                .onChange(of: message) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if message != "" {
                            showSendButton = true
                        } else {
                            showSendButton = false
                        }
                    }
                }
                .onChange(of: openAIService.isLoading || load) {
                    withAnimation {
                        message = ""
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        RadialGradientBackgroundView(shrink: .constant(true), color: Color("Bine"))
            .edgesIgnoringSafeArea(.all)
        
        ChatView(
            //          chatMessages: [],
            chatMessages: ChatMessage.sampleMessages,
//            emotion: .constant(emotions[3]),
//            causes: .constant([Cause(name: "Identitatii"), Cause(name: "Scolii")]),
            organizedSelectedTips: .constant([:])
        )
        .environmentObject(OpenAIService())
        .frame(maxWidth: MaxWidths().maxExpandedContentWidth)
        .padding(32)
    }
}
