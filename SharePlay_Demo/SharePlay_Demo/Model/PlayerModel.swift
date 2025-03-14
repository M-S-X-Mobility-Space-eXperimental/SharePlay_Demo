/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A model that represents each player's state in the SharePlay group session.
*/

import Spatial
import SwiftUI

struct PlayerModel: Codable, Hashable, Sendable, Identifiable {
    let id: UUID

    var enlarged: Bool = false
    
//    var seatPose: Pose3D?
}
