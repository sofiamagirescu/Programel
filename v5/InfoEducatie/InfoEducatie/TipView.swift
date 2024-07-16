//
//  TipView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 23.06.2024.
//

import SwiftUI

struct TipView: View {
    var tip: Tip
    var listIndex: Int
    var isSelected: Bool
    
    @Binding var shouldBeTransparentIfNotSelected: Bool
    
    var showIndexByPosition: Bool
    var isAbleToDelete: Bool
    @State private var showDeleteOption = false
    var deleteAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        if showIndexByPosition {
                            Text("\(listIndex).")
                        } else {
                            Text("\(tip.index).")
                        }
                        Spacer()
                    }
                    Text(tip.title)
                        .underline(isSelected)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .fontWeight(.bold)
                Divider()
                Text(tip.body)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .multilineTextAlignment(.leading)
            .foregroundColor(.primary)
            .padding(.vertical, 18)
            .padding(.horizontal, 22)
            .background(
                Color(.systemBackground)
                    .opacity(isSelected || !shouldBeTransparentIfNotSelected ? 1 : 0.5)
            )
            .cornerRadius(16)
            .shadow(color: .primary.opacity(0.08), radius: 12, x: 2, y: 4)
            
            
            
            HStack(spacing: 6) {
                Image(systemName:
                        showDeleteOption ? "trash" :
                        (isSelected ? "pin.fill" : "pin")
                )
                .foregroundColor(
                    showDeleteOption ? .red :
                        (isSelected ? .yellow : .secondary)
                )
                .rotationEffect(.degrees(isSelected || showDeleteOption ? 0 : 30))
                .onTapGesture {
                    if isAbleToDelete && !showDeleteOption {
                        Task {
                            withAnimation {
                                showDeleteOption = true
                            }
                            try await Task.sleep(for: .seconds(3))
                            withAnimation {
                                showDeleteOption = false
                            }
                        }
                    }
                }
                
                if showDeleteOption {
                    Text("Sterge")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.red)
                }
            }
            .font(showDeleteOption ? .subheadline : .body)
            .fontWeight(.regular)
            .padding(.horizontal, showDeleteOption ? 14 : 0)
            .padding(.vertical, showDeleteOption ? 5 : 0)
            .background(Color.red.opacity(showDeleteOption ? 0.2 : 0))
            .cornerRadius(showDeleteOption ? 200 : 0)
            .onTapGesture {
                deleteAction()
            }
//            .padding(.trailing, showDeleteOption ? -5 : 0)
            .offset(x: showDeleteOption ? 5 : 0, y: showDeleteOption ? -6 : 0)
            .padding(.vertical, 18)
            .padding(.horizontal, 22)
        }
        .animation(.smooth, value: showDeleteOption)
        .animation(.smooth, value: isSelected)
        .frame(maxWidth: MaxWidths().maxTipCardWidth)
    }
}

struct TipViewWrapper: View {
    
    @State private var isSelected = true
//    @State private var showDeleteOption = true
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            TipView(
//                tip: Tip.sampleTips[0][1],
                tip: Tip(index: 2, title: "Ajajajajajajjajajajajajjaajajjaja", body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Commodo elit at imperdiet dui accumsan sit amet."),
                listIndex: 3, isSelected: isSelected, shouldBeTransparentIfNotSelected: .constant(true), showIndexByPosition: true, isAbleToDelete: true, deleteAction: {})
                .padding(60)
                .onTapGesture {
                    withAnimation(.bouncy(duration: 0.6)) {
                        isSelected.toggle()
                    }
                }
        }
    }
}

#Preview {
    TipViewWrapper()
}
