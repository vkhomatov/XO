//
//  PlayerInputState.swift
//  XO-game
//
//  Created by Andrey Antropov on 17.05.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class PlayerInputState: GameState {
    var currentPlayer: Player? { player }
    
    let player: Player
    let markViewPrototype: MarkView
    
    weak var gameViewController: GameViewController?
    var isCompleted: Bool = false
    
    init(player: Player, gameViewController: GameViewController?, markViewPrototype: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.markViewPrototype = markViewPrototype
    }
    
    func begin() {
        switch player {
        case .first:
            
            if !gameViewController!.playWithComputer {
                gameViewController?.firstPlayerTurnLabel.text = "1st player - X"
                gameViewController?.secondPlayerTurnLabel.text = "2nd player - O"
            } else {
                gameViewController?.firstPlayerTurnLabel.text = "Player - X"
                gameViewController?.secondPlayerTurnLabel.text = "Computer - O"
            }
            
        case .second:
            
            if !gameViewController!.playWithComputer {
                gameViewController?.secondPlayerTurnLabel.text = "2nd player - O"
            } else {
                gameViewController?.secondPlayerTurnLabel.text = "Computer - O"
            }
            
        }
        gameViewController?.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        guard !isCompleted else { return }
        
        // ведем лог ходов
        Logger.shared.did(action: .playerDidAMove(player: player, position: position))
        
        gameViewController?.gameboardView.placeMarkView(markViewPrototype, at: position)
        gameViewController?.gameboard.setPlayer(player, at: position)
        isCompleted = true
        
    }
}
