/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A model that represents the current state of the game
  in the SharePlay group session.
*/

import Foundation
import GroupActivities

struct GameModel: Codable, Hashable, Sendable {
    var stage: ActivityStage = .Pre_Geyser
    
    var currentRoundEndTime: Date?
}

extension GameModel {
    enum ActivityStage: Codable, Hashable, Sendable {
        case Pre_Geyser
        case InGame_Geyser
        case After_Geyser
        
//        var isInGame: Bool {
//            if case .inGame = self {
//                true
//            } else {
//                false
//            }
//        }
    }
}
