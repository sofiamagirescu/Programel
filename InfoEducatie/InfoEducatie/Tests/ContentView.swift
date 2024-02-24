//
//  ContentView.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 14.02.2024.
//

import SwiftUI

struct ContentView: View {
    @State var tabIndex = 0
    var body: some View {
        ZStack {
            TestView(text: "SLIDE 3", color: Color.green)
                .offset(y: tabIndex == 2 ? 0 : 1000)
            TestView(text: "SLIDE 2", color: Color.red)
                .offset(y:  tabIndex == 1 ? 0 : 1000)
            TestView(text: "SLIDE 1", color: Color.accentColor)
                .offset(y: tabIndex == 0 ? 0 : -1000)
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.height < 0 {
                        withAnimation(.linear) {
                            if tabIndex < 2 {
                                tabIndex += 1
                            }
                        }
                    }
                    if value.translation.height > 0 {
                        withAnimation {
                            if tabIndex > 0 {
                                tabIndex -= 1
                            }
                        }
                    }
                })
        )
    }
}

#Preview {
    ContentView()
}
