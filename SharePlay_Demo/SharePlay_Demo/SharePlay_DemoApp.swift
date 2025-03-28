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
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    
    var body: some Scene {
        WindowGroup {
            if appModel.immersiveSpaceState == .closed {
                ContentView()
                    .environment(appModel)
                .frame(width: 1200, height: 800)
                .opacity(appModel.immersiveSpaceState == .open ? 0 : 1)
            }
        }
        .windowStyle(.volumetric)

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
        .onChange(of: appModel.sessionController?.game.stage, updateImmersiveSpaceState)
    }
    
    func updateImmersiveSpaceState(){
        Task {
            switch appModel.immersiveSpaceState {
                case .closed:
                    appModel.immersiveSpaceState = .inTransition
                    switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
                    case .opened:
                        fallthrough
                    case .userCancelled:
                        fallthrough
                    case .error:
                        fallthrough
                    @unknown default:
                        appModel.immersiveSpaceState = .closed
                    }
                    
                case .open:
                    print("immersiveSpace is opened")
                case .inTransition:
                    break
            }
        }
    }
}
