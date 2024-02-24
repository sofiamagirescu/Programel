//
//  vcuauh.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 19.02.2024.
//

import SwiftUI

struct vcuauh: View {
    
    @State var shrink = false
    
    @State var selectedState = ""
    let states = ["Fericit", "Trist", "Entuziasmat", "Stresat", "Recunoscator"]
    
    var body: some View {
        ZStack {
            Color.brown
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            Color.yellow
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(
                    RadialGradient(colors: [.indigo, .blue, .cyan, .cyan, .white], center: .center, startRadius: 50, endRadius: shrink ? 300 : 420)
                )
                .padding(-1000)
                .blur(radius: 60)
                .opacity(0.8)
            
            VStack(alignment: .leading, spacing: 36) {
//                Spacer()
//                Rectangle()
//                    .frame(height: 1.2)
//                    .padding(.vertical, 28)
//                HStack {
//                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Elementum nibh tellus molestie nunc non.")
//                        .textCase(.uppercase)
//                        .font(.title3)
//                        .fontWeight(.medium)
//                        .shadow(color: .black.opacity(0.3), radius: 10)
//                    Spacer()
//                }
                Text("Cum ne\nsimtim astazi?")
                    .font(.system(size: 42))
                    .fontWeight(.medium)
                    .padding(.bottom, 28)
                    .shadow(color: .black.opacity(0.2), radius: 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        Color.white.opacity(0)
                            .frame(width: 20, height: 1)
                        ForEach(states, id: \.self) { text in
                            Button(action: {
                                withAnimation {
                                    selectedState = text
                                }
                            }) {
                                Text(text)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 24)
                                    .background(text == selectedState ? Color.orange : Color.white)
                                    .foregroundColor(text == selectedState ? .white : .indigo)
                                    .clipShape(Capsule())
                                    .textCase(.uppercase)
                                    .fontWeight(.medium)
                            }
                        }
                        Color.white.opacity(0)
                            .frame(width: 20, height: 1)
                    }
                    .foregroundColor(.black.opacity(0.72))
                }
                .padding(.horizontal, -28)
                
                TextEditor(text: .constant("Doar scrie... fara sa te gandesti prea mult!! (max. 400 cuvinte)"))
                    .foregroundColor(.black.opacity(0.72))
                    .scrollContentBackground(.hidden)
                    .padding(18)
                    .frame(height: 240)
                    .background(.white.opacity(0.5))
                    .cornerRadius(8)
                    .padding(.bottom, 32)
                
                Button(action: {}) {
                    HStack {
                        Spacer()
                        Text("Salveaza")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .background(Color.indigo)
                    .cornerRadius(8)
                }
            }
            .foregroundColor(.white)
            .padding(28)
        }
        .onAppear {
            shrink = true
        }
        .onChange(of: shrink) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 2)) {
                    shrink.toggle()
                }
            }
        }
    }
}

#Preview {
    vcuauh()
}
