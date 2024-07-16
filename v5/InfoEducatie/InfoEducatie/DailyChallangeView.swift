//
//  DailyChallangeView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 14.07.2024.
//

import SwiftUI

struct DailyChallangeTextSectionView: View {
    
    var title: String
    var imageName: String
    var text: String
    
    @Binding var isActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: imageName)
                Text(title)
            }
            .foregroundColor(.accentColor)
            .onTapGesture {
                withAnimation {
                    isActive.toggle()
                }
            }
            
            if isActive {
                Divider()
                Text(text)
            }
        }
    }
}

struct DailyChallangeView: View {
    
    var activityDescription: String {
        if state == "Hiper" {
            return "Aceasta activitate te ajuta sa te simti mai calm pe termen scurt si sa iti controlezi mai bine emotiile pe termen lung, fiind adecvata unei zile cu hiper-activitate cognitiva."
        } else if state == "Hipo" {
            return "Aceasta activitate te ajuta sa te simti mai optimist pe termen scurt si sa iti controlezi mai bine emotiile pe termen lung, fiind adecvata unei zile cu hipo-activitate cognitiva."
        } else {
            return "Aceasta activitate te ajuta la mentinerea starii de bine pe care o ai astazi, fiind adecvata unei zile cu activitate cognitiva sanatoasa."
        }
    }
    
    @State private var showMoreInformation = false
    @State private var showFinishedView = true
    @State private var showExperience = false
    
    @State private var isCompleted = false
    
//    @State private var entryText = "M-am simtit bine yaaaaaaaa"
//    @State private var entryText = "Aceasta activitate te ajuta sa te simti mai calm pe termen scurt si sa iti controlezi mai bine emotiile pe termen lung, fiind adecvata unei zile cu hiper-activitate cognitiva. Aceasta activitate te ajuta sa te simti mai calm pe termen scurt si sa iti controlezi mai bine emotiile pe termen lung, fiind adecvata unei zile cu hiper-activitate cognitiva."
    @State private var entryText = ""
    
    var state: String
    var challangeText: String
    
    var body: some View {
        VStack(spacing: -32) {
            HStack {
                Spacer(minLength: 0)
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "bubble.circle.fill")
                    .imageScale(.large)
                Text("Provocarea Zilei")
                Spacer(minLength: 0)
                
//                Image(systemName: "chevron.down")
//                    .imageScale(.large)
//                    .fontWeight(.medium)
//                    .rotationEffect(.degrees(showMoreInformation || showFinishedView ? 0 : -90))
            }
            .padding(.bottom, 30)
            .padding(20)
            .background(Color(isCompleted ? Color.green : Color(state)))
            .fontWeight(.bold)
            .foregroundColor(Color.white)
            .cornerRadius(16)
            .shadow(color: .primary.opacity(0.08), radius: 12, x: 2, y: 4)
            
            HStack {
                VStack(alignment: .leading, spacing: 18) {
                    Text(challangeText)
                        
                    if !showFinishedView {
                        DailyChallangeTextSectionView(
                            title: "De ce aceasta activitate?",
                            imageName: "info.circle.fill",
                            text: activityDescription,
                            isActive: $showMoreInformation
                        )
                        .padding(.bottom, showMoreInformation ? 6 : 0)
                    }
                    
                    if isCompleted {
                        DailyChallangeTextSectionView(
                            title: "Experienta ta",
                            imageName: "text.bubble.fill",
                            text: entryText,
                            isActive: $showExperience
                        )
                    }
                    
                    if showFinishedView {
                        HStack {
                            Spacer(minLength: 0)
    //                        DailyChallangeTextFieldView(text: $entryText)
//                            DailyChallangeStepCheckerView()
                            DailyChallangePhotoPickerView()
                                .padding(.horizontal, -32)
                            Spacer(minLength: 0)
                        }
                    }
                    
                    
                    
                    
                    if !isCompleted {
                        Button(action: {
                            withAnimation {
                                if entryText != "" {
                                    isCompleted = true
                                    showFinishedView = false
                                } else {
                                    showFinishedView.toggle()
                                    showMoreInformation = false
                                }
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text(
                                    entryText != "" ?
                                    "Completeaza" :
                                        showFinishedView ? "Anuleaza" : "Am terminat"
                                )
                                .animation(.smooth(duration: 0.2), value: showFinishedView)
                                .font(.headline)
                                Spacer()
                            }
                        }
    //                    .padding(16)
                        .padding(14)
                        .background(
                            Color(entryText != "" ? Color(state) : Color(.systemGray6))
                        )
                        .foregroundColor(entryText != "" ? .white : .accentColor)
                        .cornerRadius(8)
                        .animation(.smooth(duration: 0.2), value: entryText == "")
                        .transition(.opacity)
                    }
                }
                Spacer(minLength: 0)
            }
            .multilineTextAlignment(.leading)
            .foregroundColor(.primary)
            .padding(.vertical, 18)
            .padding(.horizontal, 22)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .primary.opacity(0.14), radius: 12, x: 0, y: -8)
        }
        .shadow(color: .primary.opacity(0.04), radius: 12, x: 2, y: 4)
        .frame(maxWidth: MaxWidths().maxChatMessageWidth)
    }
}

#Preview {
    DailyChallangeView(state: "Hipo", challangeText: "Trimite un mesaj unui prieten cu care nu ai mai vorbit de ceva timp sau sună-l și întreabă-l cum se simte.")
        .padding(32)
}

struct DailyChallangePhotoPickerView: View {
    
    @State private var showImages = true
    
    var buttonRange: Range<Int> {
        showImages ? 0..<1 : 0..<3
    }
    
    var body: some View {
//        HStack(spacing: 24) {
//            Image(systemName: "photo.on.rectangle.angled")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 70, height: 60)
//                .foregroundColor(Color("Hipo").opacity(0.2))
////                .shadow(color: Color("Hipo").opacity(0.8), radius: 24, x: 0, y: 12)
//            
//            VStack(alignment: .leading) {
//                Text("Nr. de pasi astazi:")
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//                Text("1638 / 2500")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                ProgressView(value: 0.64)
//            }
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 12)
        
        VStack(spacing: 6) {
            Image(systemName: "photo.badge.plus")
                .imageScale(.large)
            Text("Selecteaza poze din galerie pentru a contina")
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.bottom, 16)
                .padding(.horizontal, 64)
                .foregroundColor(.secondary)
            
            HStack(spacing: 14) {
                Color.white
                    .frame(width: 32 + 18, height: 84)
                    .padding(.trailing, (-14 - 18))
                Button(action: {
                    withAnimation {
                        showImages.toggle()
                    }
                }) {
                    HStack(spacing: -64) {
                        ForEach(buttonRange, id: \.self) { i in
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 84, height: 84)
                                    .foregroundColor(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 6)
                                if i == 0 {
                                    Image(systemName: "plus")
                                        .imageScale(.large)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .rotationEffect(.degrees(Double(showImages ? 0 : (i-1) * 4)))
                            .padding(.top, Double(i * 2))
                            .zIndex(Double(i * -1))
                        }
                    }
                }
                
                if showImages {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(0..<5) { _ in
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 84, height: 84)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.trailing, 32)
                    }
                    .scrollClipDisabled()
                }
            }
        }
        .padding(.top, 4)
        .padding(.bottom, 16)
    }
}

struct DailyChallangeStepCheckerView: View {
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: "shoeprints.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 60)
                .foregroundColor(Color("Hipo").opacity(0.2))
//                .shadow(color: Color("Hipo").opacity(0.8), radius: 24, x: 0, y: 12)
            
            VStack(alignment: .leading) {
                Text("Nr. de pasi astazi:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("1638 / 2500")
                    .font(.title2)
                    .fontWeight(.bold)
                ProgressView(value: 0.64)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct DailyChallangeTextFieldView: View {
    
    @Binding var text: String
    
    var body: some View {
        TextField("Cum te-ai simtit in timpul acestei activitati?", text: $text, axis: .vertical)
            .tint(.secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .lineLimit(3...4)
            .foregroundColor(.primary)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.secondary, lineWidth: 0.2)
            )
    }
}
