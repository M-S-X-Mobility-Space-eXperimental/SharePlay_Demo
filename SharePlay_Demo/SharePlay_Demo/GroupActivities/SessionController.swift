/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
An observable controller class that manages the active SharePlay
  group session.
*/

import GroupActivities
import Observation

@Observable @MainActor
class SessionController {
    let session: GroupSession<PlayTogether>
    let messenger: GroupSessionMessenger
    let systemCoordinator: SystemCoordinator
    
    var players = [Participant: PlayerModel]()
//    {
//        didSet {
//            if oldValue != players {
//                updateCurrentPlayer()
//                updateLocalParticipantRole()
//            }
//        }
//    }
    
    var localPlayer: PlayerModel {
        get {
            players[session.localParticipant]!
        }
        set {
            if newValue != players[session.localParticipant] {
                players[session.localParticipant] = newValue
                shareLocalPlayerState(newValue)
            }
        }
    }
    
    init?(_ session: GroupSession<PlayTogether>, appModel: AppModel) async {
        guard let systemCoordinator = await session.systemCoordinator else {
            return nil
        }
        
        self.session = session
        self.messenger = GroupSessionMessenger(session: session)
        self.systemCoordinator = systemCoordinator
        
        self.localPlayer = PlayerModel(
            id: session.localParticipant.id
        )
        
        observeRemoteParticipantUpdates()
        configureSystemCoordinator()
        
        self.session.join()
    }
    
    func configureSystemCoordinator() {
        systemCoordinator.configuration.supportsGroupImmersiveSpace = true
        systemCoordinator.configuration.spatialTemplatePreference = .surround
    }
    
    //send local player state message via messenger
    func shareLocalPlayerState(_ newValue: PlayerModel) {
        Task {
            do {
                try await messenger.send(newValue)
            } catch {
                print("Failed to send the PlayerState message.")
            }
        }
    }
    
    func observeRemoteParticipantUpdates() {
        observeRemotePlayerModelUpdates()
    }
    
    private func observeRemotePlayerModelUpdates() {
        Task {
            for await (player, context) in messenger.messages(of: PlayerModel.self) {
                players[context.source] = player
                if player.enlarged != self.localPlayer.enlarged {
                    self.localPlayer.enlarged.toggle() //*************
                }

            }
        }
    }
}
