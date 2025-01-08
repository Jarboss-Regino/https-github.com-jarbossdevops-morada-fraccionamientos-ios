//
//  SplashScreen.swift
//  morada-fraccionamientos-ios
//
//  Created by MacBook Air on 17/12/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var opacity = 0.0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5)) {
                            opacity = 1.0
                        }
                    }
                Text("Morada")
                    .font(.title)
                    .fontWeight(.bold)
                    .opacity(opacity)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                            .mask({
                                Text("Morada")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .opacity(opacity)
                            })
                    )
            }
        }
    }
}

#Preview {
    SplashScreen()
}
