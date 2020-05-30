//
//  GameFinishedState.swift
//  XO-game
//
//  Created by Andrey Antropov on 17.05.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class GameFinishedState: GameState {
    
    let currentPlayer: Player?
    weak var gameViewController: GameViewController?
    var isCompleted: Bool = false
    
    init(player: Player?, gameViewController: GameViewController?) {
        self.currentPlayer = player
        self.gameViewController = gameViewController
    }
    
    func begin() {
        Logger.shared.did(action: .gameFinished(winner: currentPlayer))
     //   gameViewController?.firstPlayerTurnLabel.isHidden = true
     //   gameViewController?.secondPlayerTurnLabel.isHidden = true
        gameViewController?.winnerLabel.isHidden = false
        
        let winnerText: String
        switch currentPlayer {
        case .some(.first):
            winnerText = "First player won"
        case .some(.second):
            guard let controller = gameViewController else { return }
            if controller.playWithComputer {
                winnerText = "Computer won"
            } else {
                winnerText = "Second player won"
            }
        case .none:
            winnerText = "Draw"
        }
        gameViewController?.winnerLabel.text = winnerText
    }
    
    func addMark(at position: GameboardPosition) { }
}
