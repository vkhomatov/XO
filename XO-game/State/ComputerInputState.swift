//
//  ComputerInputState.swift
//  XO-game
//
//  Created by Vitaly Khomatov on 26.05.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class ComputerInputState: GameState {
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

            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.text = "Computer"
            gameViewController?.secondPlayerTurnLabel.isHidden = false
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
