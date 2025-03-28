//
//  WelcomeView.swift
//  SharePlay_Demo
//
//  Created by ChuanZhen Tu on 3/28/25.
//

import GroupActivities
import SwiftUI

struct WelcomeView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        VStack {
            Image("yellowstone_logo")
                        .resizable()
                        .scaledToFit()
            
            Text("Explore Yellowstone Together!")
                .font(.extraLargeTitle)
            
            Text("""
                Welcome to Explore Yellowstone National Park Together, a future edutainment experience in a Honda vehicle! \
                \n\nTo play, join a FaceTime call with family members or friends. \
                \n\nYou'll explore the secrets and learn the fun facts behind various attractions.
                """
            )
            .multilineTextAlignment(.center)
            .padding()
            
            Divider()
            
            Button("Print Activity Stage") {
                print(appModel.sessionController?.game.stage ?? "sessionController not initialized yet.")
            }
            
            SharePlayButton().padding(.vertical, 20)
        }
        
//        .padding(.horizontal)
    }
}

struct SharePlayButton: View {
    @StateObject
    var groupStateObserver = GroupStateObserver()
    
    var body: some View {
        ZStack {
            ShareLink(
                item: PlayTogether(),
                preview: SharePreview("Explore Together!")
            )
            .hidden()
            
            Button("Explore Yellowstone Together", systemImage: "shareplay") {
                Task.detached {
                    try await PlayTogether().activate()
                }
            }
            .disabled(!groupStateObserver.isEligibleForGroupSession)
            .tint(.green)
        }
    }
}


#Preview {
    WelcomeView()
        .environment(AppModel())
}
