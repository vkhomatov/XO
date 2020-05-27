//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    //  @IBOutlet var restartButton: UIButton!
    
    var playWithComputer : Bool = false
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Logger.shared.did(action: .restartGame)
        gameboard.clear()
        gameboardView.clear()
        currentState = PlayerInputState(player: .first, gameViewController: self, markViewPrototype: firstPlayerMarkViewPrototype.copy())
    }
    
    
    let firstPlayerMarkViewPrototype: XView = {
        let markView = XView()
        markView.lineColor = .green
        markView.lineWidth = 5
        return markView
    }()
    
    let secondPlayerMarkViewPrototype: OView = {
        let markView = OView()
        markView.lineColor = .red
        markView.lineWidth = 10
        return markView
    }()
    
    let gameboard = Gameboard()
    
    var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    lazy var referee = Referee(gameboard: self.gameboard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            let busyCell = self.gameboard.containsXO(at: position)
            
            if !busyCell {
                
                if !self.playWithComputer {
                    self.currentState.addMark(at: position)
                    self.switchToNextStateComp()
                } else {
                    self.currentState.addMark(at: position)
                    self.switchToNextStateComp()
                    
                    self.currentState.addMark(at: self.generateCompStep())
                    self.switchToNextStateComp()
                }
            } else {
                print("Клетка занята")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentState = PlayerInputState(player: .first, gameViewController: self, markViewPrototype: firstPlayerMarkViewPrototype.copy())
        
    }
    
    // генерация хода компьютера
    func generateCompStep() -> GameboardPosition {
        var compPosition = GameboardPosition(column: 1, row: 1)
        if  self.gameboard.containsXO(at: compPosition) {
            compPosition = GameboardPosition(column: 0, row: 0)
            if  self.gameboard.containsXO(at: compPosition) {
                compPosition = GameboardPosition(column: 0, row: 2)
                if  self.gameboard.containsXO(at: compPosition) {
                    compPosition = GameboardPosition(column: 2, row: 2)
                    if  self.gameboard.containsXO(at: compPosition) {
                        compPosition = GameboardPosition(column: 2, row: 0)
                        
                        for y in 0...2 {
                            for x in 0...2 {
                                if !self.gameboard.containsXO(at: GameboardPosition(column: y, row: x)) {
                                    compPosition = GameboardPosition(column: y, row: x)
                                }
                            }
                        }
                    }
                }
            }
        }
        return compPosition
    }
    
    func generateCompStepAI() -> GameboardPosition {
        var compPosition = GameboardPosition(column: 1, row: 1)
        
        return compPosition
    }
    
    
    
    //    private func switchToNextState() {
    //        guard currentState.isCompleted else { return }
    //
    //        if let winner = referee.determineWinner() {
    //            currentState = GameFinishedState(player: winner, gameViewController: self)
    //        } else if !gameboard.gotAvailablePositions {
    //            currentState = GameFinishedState(player: nil, gameViewController: self)
    //        } else if let nextPlayer = currentState.currentPlayer?.next {
    //            let markView: MarkView = nextPlayer == .first ? firstPlayerMarkViewPrototype.copy() : secondPlayerMarkViewPrototype.copy()
    //            currentState = PlayerInputState(player: nextPlayer, gameViewController: self, markViewPrototype: markView)
    //        }
    //    }
    
    private func switchToNextStateComp() {
        guard currentState.isCompleted else { return }
        
        if let winner = referee.determineWinner() {
            currentState = GameFinishedState(player: winner, gameViewController: self)
            
        } else if !gameboard.gotAvailablePositions {
            currentState = GameFinishedState(player: nil, gameViewController: self)
            
        } else if let nextPlayer = currentState.currentPlayer?.next {
            let markView: MarkView = nextPlayer == .first ? firstPlayerMarkViewPrototype.copy() : secondPlayerMarkViewPrototype.copy()
            
            if playWithComputer {
                switch nextPlayer {
                case .first:
                    currentState = PlayerInputState(player: nextPlayer, gameViewController: self, markViewPrototype: markView)
                case .second:
                    currentState = ComputerInputState(player: nextPlayer, gameViewController: self, markViewPrototype: markView)
                }
            } else {
                currentState = PlayerInputState(player: nextPlayer, gameViewController: self, markViewPrototype: markView)
                
            }
            
        }
        
    }
    
    
    
    
}

