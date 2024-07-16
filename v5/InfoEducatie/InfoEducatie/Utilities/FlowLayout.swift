//
//  FlowLayout.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 22.06.2024.
//

import SwiftUI

struct FlowLayout<Content: View>: View {
    let items: [String]
    let spacing: CGFloat
    let content: (String) -> Content

    @State private var totalHeight
        = CGFloat.zero
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
            .frame(height: totalHeight)
        }
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
//        var lastElementWidth = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.items, id: \.self) { item in
                self.content(item)
                    .padding(.horizontal, 2)
                    .padding(.vertical, 6)
                    .alignmentGuide(.leading) { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == self.items.last {
                            width = 0
                        } else {
                            width -= d.width + self.spacing
                        }
//                        lastElementWidth = width
                        return result
                    }
                    .alignmentGuide(.top) { d in
                        let result = height
                        if item == self.items.last {
                            height = 0
                        }
                        return result
                    }
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
