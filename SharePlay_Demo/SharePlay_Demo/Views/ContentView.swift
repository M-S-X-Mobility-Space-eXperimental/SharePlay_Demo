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
    
    var body: some View {
        Group {
            switch appModel.sessionController?.game.stage {
            case .none:
                WelcomeView()
            case .Pre_Geyser:
                Pre_Geyser_View()
            case .InGame_Geyser:
                WelcomeView()
            case .After_Geyser:
                WelcomeView()
            }
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

#Preview(windowStyle: .plain) {
    ContentView()
        .environment(AppModel())
}
