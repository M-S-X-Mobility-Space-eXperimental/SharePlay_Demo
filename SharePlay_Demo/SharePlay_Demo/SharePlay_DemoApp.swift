//
//  SharePlay_DemoApp.swift
//  SharePlay_Demo
//
//  Created by ChuanZhen Tu on 3/13/25.
//

import SwiftUI

@main
struct SharePlay_DemoApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environment(appModel)
            }
            .frame(width: 900, height: 600)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
