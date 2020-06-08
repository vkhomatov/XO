//
//  XOInvoker.swift
//  XO-game
//
//  Created by Vitaly Khomatov on 05.06.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

class XOInvoker {
    
    var xCommands = [XOCommand]()
    var oCommands = [XOCommand]()
    public var endOfGame: (() -> Void)?
    
    
    func addComand(сommand: XOCommand) {
        
        switch сommand.player {
        case .first:
            xCommands.append(сommand)
        case .second:
            oCommands.append(сommand)
        }
        //  print("Добавлена комманда: \(xoCommand.position) игрок: \(xoCommand.player)")
    }
    
    func clear() {
        xCommands.removeAll()
        oCommands.removeAll()
    }
    
    func runCommands(gameViewController: GameViewController) {
        DispatchQueue.global(qos: .default).async {
            
            for command in 0...self.xCommands.count-1 {
                self.xCommands[command].execute(gameViewController: gameViewController)
                sleep(1)
                self.oCommands[command].execute(gameViewController: gameViewController)
                sleep(1)
                
            }
            self.endOfGame?()
        }
        
    }
    
}
