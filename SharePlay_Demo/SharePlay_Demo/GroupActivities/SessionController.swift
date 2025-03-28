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
    
    var game: GameModel {
        get {
            gameSyncStore.game
        }
        set {
            if newValue != gameSyncStore.game {
                gameSyncStore.game = newValue
                shareLocalGameState(newValue)
                gameStateChanged()
            }
        }
    }
    
    var gameSyncStore = GameSyncStore() {
        didSet {
            gameStateChanged()
        }
    }
    
    struct GameSyncStore {
        var game = GameModel()
    }
    
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
    
    //send game model state message via messenger
    func shareLocalGameState(_ newValue: GameModel) {
        Task {
            do {
                try await messenger.send(newValue)
            } catch {
                // Failed to send the message.
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
                if player.success != self.localPlayer.success {
                    self.localPlayer.success.toggle() //*************
                }
            }
        }
    }
    
    func gameStateChanged() {
        updateSpatialTemplatePreference()
    }
    
    func enter_geyser_set_off_game() {
        game.stage = .InGame_Geyser
        game.currentStageTimeLeft = 5.0
    }
    
    func updateSpatialTemplatePreference() {
        switch game.stage {
        case .Pre_Geyser:
            systemCoordinator.configuration.spatialTemplatePreference = .surround
        case .InGame_Geyser:
            systemCoordinator.configuration.spatialTemplatePreference = .surround
        case .After_Geyser:
            systemCoordinator.configuration.spatialTemplatePreference = .surround
        }
    }
}
