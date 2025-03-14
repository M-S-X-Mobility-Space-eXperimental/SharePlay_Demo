//
//  ContentView.swift
//  SharePlay_Demo
//
//  Created by ChuanZhen Tu on 3/13/25.
//

import SwiftUI
import RealityKit
import RealityKitContent
import GroupActivities

struct ContentView: View {
    @Environment(AppModel.self) var appModel
    @State var enlarged: Bool = false

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
            }
        } update: { content in
            // Update the RealityKit content when SwiftUI state changes
            if let scene = content.entities.first {
                let uniformScale: Float = appModel.sessionController?.localPlayer.enlarged ?? enlarged ? 1.4 : 1.0
                scene.transform.scale = [uniformScale, uniformScale, uniformScale]
            }
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
            appModel.sessionController?.localPlayer.enlarged.toggle()
        })
        .toolbar {
//            ToolbarItemGroup(placement: .bottomOrnament) {
                VStack (spacing: 12) {
                    Button {
                        if appModel.sessionController == nil {
                            enlarged.toggle()
                        }
                        appModel.sessionController?.localPlayer.enlarged.toggle()
                    } label: {
                        Text(appModel.sessionController?.localPlayer.enlarged ?? enlarged ? "Reduce RealityView Content" : "Enlarge RealityView Content")
                    }
                    .animation(.none, value: 0)
                    .fontWeight(.semibold)
                    
                    Button {
                        if let players = appModel.sessionController?.players {
                            print("players size: \(players.count)")
//                            for (participant, playerModel) in players {
//                                print("Participant ID: \(participant.id)")
//                                print("Player enlarged bool: \(playerModel.enlarged)")
//                                print("-----------------------")
//                            }
                        }
                    } label: {
                        Text("print")
                    }
                    
                    SharePlayButton().padding(.vertical, 20)
                    ToggleImmersiveSpaceButton()
                }
//            }a
        }
        .task(observeGroupSessions)
    }
    
    @Sendable
    func observeGroupSessions() async {
        for await session in PlayTogether.sessions() {
            let sessionController = await SessionController(session, appModel: appModel)
            guard let sessionController else {
                continue
            }
            appModel.sessionController = sessionController

            // Create a task to observe the group session state and clear the
            // session controller when the group session invalidates.
            Task {
                for await state in session.$state.values {
                    guard appModel.sessionController?.session.id == session.id else {
                        return
                    }

                    if case .invalidated = state {
                        appModel.sessionController = nil
                        return
                    }
                }
            }
        }
    }
}

struct SharePlayButton: View {
    @StateObject
    var groupStateObserver = GroupStateObserver()
    
    var body: some View {
        ZStack {
            ShareLink(
                item: PlayTogether(),
                preview: SharePreview("Play Together!")
            )
            .hidden()
            
            Button("Play Together", systemImage: "shareplay") {
                Task.detached {
                    try await PlayTogether().activate()
                }
            }
            .disabled(!groupStateObserver.isEligibleForGroupSession)
            .tint(.green)
        }
    }
}



#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(AppModel())
}
