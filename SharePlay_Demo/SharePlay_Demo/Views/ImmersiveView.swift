//
//  ImmersiveView.swift
//  SharePlay_Demo
//
//  Created by ChuanZhen Tu on 3/13/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel
    
    var body: some View {
        RealityView { content, attachments in
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)
            }
            
            if let sandbox = try? await Entity(named: "Sandbox", in: realityKitContentBundle) {
                
                content.add(sandbox)
                
                if let sandboxAttachment = attachments.entity(for: "Pre_Geyser") {
                    sandboxAttachment.position = [-0.7, 1.0, -0.2]
                    sandboxAttachment.transform.rotation = simd_quatf(angle: Float.pi / 2, axis: [0, 1, 0])
                    sandbox.addChild(sandboxAttachment)
                }
            }
        }
        attachments:{
            Attachment(id: "Pre_Geyser") {
                ContentView()
            }
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded { value in
                _ = value.entity.applyTapForBehaviors()
            }
        )
    }
}


#Preview(immersionStyle: .full) {
    ImmersiveView()
        .environment(AppModel())
}
