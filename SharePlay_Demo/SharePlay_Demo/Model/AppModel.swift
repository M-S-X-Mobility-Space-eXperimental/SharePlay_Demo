//
//  AppModel.swift
//  SharePlay_Demo
//
//  Created by ChuanZhen Tu on 3/13/25.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var sessionController: SessionController?
}
