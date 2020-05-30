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
           // gameViewController?.firstPlayerTurnLabel.textColor = .green
          //  gameViewController?.secondPlayerTurnLabel.textColor = .red
            if !gameViewController!.playWithComputer {
                gameViewController?.firstPlayerTurnLabel.text = "1st player - X"
                gameViewController?.secondPlayerTurnLabel.text = "2nd player - O"

            } else {
                gameViewController?.firstPlayerTurnLabel.text = "Player - X"
                gameViewController?.secondPlayerTurnLabel.text = "Computer - O"


            }

          //  gameViewController?.firstPlayerTurnLabel.isHidden = false
          //  gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
          //  gameViewController?.firstPlayerTurnLabel.isHidden = true
        //    gameViewController?.firstPlayerTurnLabel.textColor = .red
            if !gameViewController!.playWithComputer {
                gameViewController?.secondPlayerTurnLabel.text = "2nd player - O"
            } else {
               gameViewController?.secondPlayerTurnLabel.text = "Computer - O"

            }
           // gameViewController?.secondPlayerTurnLabel.text = "2nd player"
         //   gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        gameViewController?.winnerLabel.isHidden = true
    }
    
    func addMark(at position: GameboardPosition) {
        guard !isCompleted else { return }
        
        // ведем лог ходов
        Logger.shared.did(action: .playerDidAMove(player: player, position: position))
        
//        guard let busyCell = gameViewController?.gameboard.contains(player: player, at: position) else { return }
//
//        if !busyCell {
        // 
        gameViewController?.gameboardView.placeMarkView(markViewPrototype, at: position)
        gameViewController?.gameboard.setPlayer(player, at: position)
        
        isCompleted = true
//        } else {
//            print("Клетка занята")
//        }
    }
}
