//
//  Pre_Geyser_View.swift
//  SharePlay_Demo
//
//  Created by ChuanZhen Tu on 3/28/25.
//

import SwiftUI

struct Pre_Geyser_View: View {
    @Environment(AppModel.self) var appModel
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        VStack{
            Image("Old_Faithful_Geyser")
                .resizable()
                .scaledToFit()
                .frame(width: 360, height: 240)
            
            Text("Old Faithful Geyser")
                .bold()
                .font(.largeTitle)
            Divider()
            
            if (appModel.sessionController?.game.stage == .none ||
                appModel.sessionController?.game.stage == .Pre_Geyser) {
                AnimatedTypingText(fullText: "Our journey begins at the legendary Old Faithful Geyser, a geothermal marvel renowned for its remarkable punctuality. Every 90 minutes, deep beneath the Earth's surface, tremendous pressures build. Steam bubbles expand, and water temperatures surge, until at precisely the right moment—visitors, it’s now your turn to trigger this extraordinary event. Snap your fingers together, and witness Old Faithful burst forth, shooting thousands of gallons of steaming hot water nearly 180 feet into the sky. Feel the thrill of participating directly in this spectacular eruption, becoming one with Yellowstone’s rhythmic heartbeat.")
            }
            else if appModel.sessionController?.game.stage == .After_Geyser {
                AnimatedTypingText(fullText: "This incredible display occurs due to water heated deep underground by magma chambers. Temperatures here can exceed 350 degrees Fahrenheit, creating immense pressure that propels the water upward with impressive force. Fun fact: Old Faithful has erupted over a million times since Yellowstone became a national park in 1872, demonstrating its stunning consistency. Each eruption, uniquely powerful yet elegantly rhythmic, is a vivid reminder of the dynamic geological processes constantly reshaping our planet beneath our very feet.")
            }
        }
        .onChange(of: appModel.immersiveSpaceState){
            dismissWindow()
        }
        .padding()
        .padding(.horizontal, 100)
        .frame(width: 1200, height: 800)
        .glassBackgroundEffect()
    }
}

struct AnimatedTypingText: View {
    let fullText: String
    @State private var displayedText = ""
    @State private var timer: Timer?
    
    var body: some View {
        Text(displayedText)
            .font(.title)
            .onAppear {
                displayedText = ""
                timer?.invalidate()
                
                var charIndex = 0
                timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
                    if charIndex < fullText.count {
                        let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                        displayedText += String(fullText[index])
                        charIndex += 1
                    } else {
                        timer.invalidate()
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
    }
}


#Preview {
    Pre_Geyser_View()
}
