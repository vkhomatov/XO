//
//  XOCommand.swift
//  XO-game
//
//  Created by Vitaly Khomatov on 05.06.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class XOCommand {
    
    var player: Player
    var position: GameboardPosition
    
    init(player: Player, position: GameboardPosition) {
        self.player = player
        self.position = position
    }
    
    func execute(gameViewController: GameViewController) {
        
        
        if  !gameViewController.gameboard.contains(player: self.player, at: self.position)  {
            
            DispatchQueue.main.async {
                
                gameViewController.gameboardView.removeMarkView(at: self.position)
            }
            
            sleep(1)
            
        }
        
        DispatchQueue.main.async {
            
            var markView = MarkView()
            
            switch self.player {
            case .first:
                markView = gameViewController.firstPlayerMarkViewPrototype.copy()
            case .second:
                markView = gameViewController.secondPlayerMarkViewPrototype.copy()
            }
            gameViewController.gameboardView.placeMarkView(markView, at: self.position)
            
        }
        
        gameViewController.gameboard.setPlayer(self.player, at: self.position)
        
    }
    
}
