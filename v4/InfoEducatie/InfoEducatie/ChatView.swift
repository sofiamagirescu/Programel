//
//  ChatView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 17.06.2024.
//

import SwiftUI
import AVFoundation
import Combine

let openAIKey = "nahhhhhhh nu va iese"

struct ChatView: View {
    
    @EnvironmentObject var openAIService: OpenAIService
    
    @State var chatMessages: [ChatMessage]
    @Binding var emotion: CurrentEmotion
    @Binding var causes: [String]
    
    @State var message = ""
    @State var showSendButton = false
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var prompt: String {
//        "SISTEM: Esti un asistent personal pentru utilizator. Scopul tau este sa discuti cu el despre cum a fost si ce s-a intamplat in ziua de astazi si sa il ajuti sa isi inteleaga mai bine sentimentele. Ofera-i intrebari scurte, care il indruma in directia cea buna si cuvinte de incurajare din cand in cand, la fel, scurte, dar calde. Daca utilizatorul iti cere un sfat sau ceva legat de dezvoltare personala, nu insista asupra discutiei legate de ziua de astazi, ci ofera-i ajutor si raspunde-i la intrebari; poti reveni la situatia zilei doar dupa ce intrebarile sunt raspunse si sfaturile sunt date etc. Daca utilizatorul intreaba ceva ce nu e legat de dezvoltare personala, refuza sa-i raspunzi politicos. Vorbeste ca si cum esti prietenul lui si asigura-te ca se simte inteles si ca nu e judecat). Conversatia sa fie fluida si daca nu schimba utilizatorul subiectul, atunci schimba-l tu. Numele utilizatorului este \(userFirstName) si foloseste pronume \(userPronouns). In momentul de fata, se simte \(emotion.name.lowercased()), datorita \(causes.joined(separator: " + ").lowercased()). Foloseste aceste informatii pe parcursul conversatiei. Initiaza conversatia fara a face referinta la aceste instructiuni."
        
        "SISTEM: Esti un asistent personal pentru utilizator. Numele utilizatorului este \(userFirstName) si foloseste pronume \(userPronouns). In momentul de fata, se simte \(emotion.name.lowercased()), datorita \(causes.joined(separator: " + ").lowercased()). Scopul tău este sa îl faci sa-si inteleaga mai bine sentimentele, sa proceseze cum au contribuit cauzele mentionate mai sus + evenimentele de astăzi la starea lui actuala si să-i dai sfaturi / soluții. Ofera-i intrebari scurte, care il indruma spre directia cea buna si cuvinte de incurajare din cand in cand, la fel, scurte, dar calde. Daca utilizatorul intreaba ceva ce nu e legat de dezvoltare personala, refuza sa-i raspunzi politicos. Vorbeste pe un ton cald, semi-haios si intelegator, ca si cum esti prietenul lui si asigura-te ca nu se simte judecat. Conversatia sa fie fluida si daca nu schimba utilizatorul subiectul pentru mult timp, atunci schimba-l tu. \(userFirstName) a completat deja un chestionar, unde si-a specificat starea si ce a cauzat-o vag (vezi mai sus), deci poti sa incepi direct cu esenta. Initiaza conversatia fara a face referire la aceste instructiuni. Incearca sa nu pui intrebari extrem de generale dupa primele cateva mesaje. Nu presupune nimic (de exemplu daca apare mai sus ca utilizatorul se simte prost nu-l intreba de ce e complesit, intreaba-l de ce se simte prost si atat, sau, daca scrie mai sus de fitness, nu il intreba de antrenament, MAI PUTIN CAND SPECIFICA UTILIZATORUL INSUSI."
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    Color.red.opacity(0).frame(width: 1, height: 6)
                    
                    Text("In sfarsit...")
                    
                    Text("Haide sa aprofundam!")
                        .font(.custom("DMSerifDisplay-Regular", size: 36))
                    
                    Divider()
                        .padding(.vertical, 18)
                }
                
                VStack(spacing: 14) {
                    ForEach(chatMessages) { message in
                        HStack(alignment: .bottom) {
                            if message.sender == .user { Spacer(minLength: 80) }
                            
                            Text(message.content)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .foregroundColor(message.sender == .user ? .white : .black)
                                .background(Color(message.sender == .user ? .blue : .white))
                                .cornerRadius(12)
//                                .onTapGesture {
//                                    if message.sender == .gpt {
//                                        speakText(text: message.content)
//                                    }
//                                }
                            
                            if message.sender == .gpt { Spacer(minLength: 80) }
                        }
                    }
                    
//                    if openAIService.isLoading && !openAIService.isInitialLoading {
                    if openAIService.isLoading {
                        HStack {
                            ProgressView()
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            Spacer(minLength: 80)
                        }
                    }
                }
                
                // sa fie mereu umplut scroll view-ul ca sa fie smooth animatia cu tastatura
                GeometryReader { innerGeometry in
                    Color.clear
                        .frame(height: innerGeometry.size.height)
                        .background(
                            VStack {
                                Spacer()
                                if outerGeometry.frame(in: .global).height > innerGeometry.frame(in: .global).maxY {
                                    Color.red
                                }
                            }
                        )
                }
                
                
                Color.red.opacity(0).frame(width: 1, height: 6)
            }
            .mask(
                VStack(spacing: 0) {
                    LinearGradient(colors: [.red.opacity(0), .red], startPoint: .top, endPoint: .bottom).frame(height: 6)
                    Color.red
                    LinearGradient(colors: [.red.opacity(0), .red], startPoint: .bottom, endPoint: .top).frame(height: 6)
                }
            )
            .shadow(color: Color.black.opacity(0.02), radius: 6, x: 4, y: 8)
            .defaultScrollAnchor(.bottom)
            
            
            ZStack(alignment: .bottomTrailing) {
                TextField("Scrie un mesaj...", text: $message, axis: .vertical)
                    .padding(.leading, 16)
                    .padding(.trailing, 58)
                    .padding(.vertical, 12)
                    .lineLimit(1...12)
                    .frame(minHeight: 50)
                    .background(Color.white.blendMode(.overlay))
                    .cornerRadius(12)
                
                
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
                            .frame(width: 38, height: 38)
                            .background(Color.black)
                            .cornerRadius(12)
                            .rotationEffect(.degrees(90))
                    }
                    .staggeredAppear(isVisible: showSendButton, index: 0, offset: 3, duration: 0.24)
                    .rotationEffect(.degrees(-90))
                    .padding(6)
            }
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        hideKeyboard()
                    }
//                    .onEnded { _ in
//                    }
            )
        }
        .onAppear {
//            openAIService.initialize(initialPrompt: prompt)
        }
        .onReceive(openAIService.$responseMessage) { response in
            if !response.isEmpty {
                withAnimation {
                    chatMessages.append(ChatMessage(id: UUID().uuidString, content: response, dateCreated: Date(), sender: .gpt))
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
    }
    
    private func speakText(text: String) {
        print("Attempting to speak text: \(text)")
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate) // Stop any ongoing speech
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Set Romanian language
        utterance.rate = 0.5 // Adjust the rate if needed
        synthesizer.speak(utterance)
        
        if synthesizer.isSpeaking {
            print("Synthesizer is speaking")
        } else {
            print("Synthesizer is not speaking")
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    @Published var currentHeight: CGFloat = 0
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        let willShowPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                self.isKeyboardVisible = true
                return notification.keyboardHeight
            }
        
        let willHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in
                self.isKeyboardVisible = false
                return 0
            }
        
        Publishers.Merge(willShowPublisher, willHidePublisher)
            .assign(to: \.currentHeight, on: self)
            .store(in: &cancellableSet)
    }
    
    deinit {
        cancellableSet.forEach { $0.cancel() }
    }
}


private extension Notification {
    var keyboardHeight: CGFloat {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
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
    ChatView(
//        chatMessages: [],
        chatMessages: ChatMessage.sampleMessages,
        emotion: .constant(CurrentEmotion(name: "Prost", color: Color.white)),
        causes: .constant(["Identitatii", "Scolii"])
    )
    .environmentObject(OpenAIService())
    .padding(32)
    .background(Color(.systemGray5))
}
