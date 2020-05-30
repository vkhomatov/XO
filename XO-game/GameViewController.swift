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
    
    private var xoPositions = [[GameboardPosition]]()
    private let computerBrain = ComputerBrain()
    private let dummyXO: Int = 10
    private let X = 10
    private let O = 1
    let gameboard = Gameboard()


    var playWithComputer : Bool = false

    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Logger.shared.did(action: .restartGame)
        gameboard.clear()
        gameboardView.clear()
        currentState = PlayerInputState(player: .first, gameViewController: self, markViewPrototype: firstPlayerMarkViewPrototype.copy())
        resetXOPositions(dummy: dummyXO)
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
        markView.lineWidth = 6
        return markView
    }()
    
    
    var currentState: GameState! {
        didSet {
            currentState.begin()
        }
    }
    
    lazy var referee = Referee(gameboard: self.gameboard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstPlayerTurnLabel.textColor = .green
        secondPlayerTurnLabel.textColor = .red
        resetXOPositions(dummy: dummyXO)

        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            let busyCell = self.gameboard.containsXO(at: position)
            
            if !busyCell {
                
                if !self.playWithComputer {
                    self.currentState.addMark(at: position)
                    self.switchToNextStateComp()
                } else {
                    
                    // ход игрока
                    self.currentState.addMark(at: position)
                    
                    // сохраняем позицию хода игрока в массив
                    //self.xoPositions[position.column][position.row] = position
                    self.xoPositions[position.column][position.row].sing = self.X
                    
                    
                    // переключаемся на стейт компьютера
                    self.switchToNextStateComp()
                    
                    // генерируем ход компа исходя из игровой ситуации
                    let compPosition = self.computerBrain.generatePosition(xoPositions: self.xoPositions, gameboard: self.gameboard, X: self.X, O: self.O)
                    // self.xoPositions[compPosition.column][compPosition.row] = compPosition
                    self.xoPositions[compPosition.column][compPosition.row].sing = self.O
                    
                    // ход компьютера
                    self.currentState.addMark(at: compPosition)
                    
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
    
    // заполняем массив игрового поля пустыми значениями
    func resetXOPositions(dummy: Int)
    {
        xoPositions.removeAll()
        for _ in 0 ..< GameboardSize.columns {
            var row = [GameboardPosition]()
            for _ in 0 ..< GameboardSize.rows {
                row.append(GameboardPosition(column: dummy, row: dummy))
            }
            xoPositions.append(row)
        }
    }
  
    // переключаемся на следующий стейт
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


























 





     // генерация хода компьютера - рассчет координаты хода исходя из координат выполненных ходов
    
    /*   func generatePosition() -> GameboardPosition {
     var position = GameboardPosition(column: 1, row: 1, sing: O)
     var diaSummLR: Int = 0
     var diaSummRL: Int = 0
     
     
     
     // проходим по строчкам
     for row in 0 ..< GameboardSize.rows {
     
     var rowSumm: Int = 0
     
     for column in 0 ..< GameboardSize.columns {
     
     rowSumm += xoPositions[column][row].column
     }
     
     if rowSumm >= dummyXO + 1 && rowSumm <= dummyXO + GameboardSize.rows {
     position = GameboardPosition(column: (rowSumm - dummyXO - GameboardSize.columns) * (-1), row: row, sing: O)
     return position
     }
     }
     
     // проходим по столбцам
     for column in 0 ..< GameboardSize.columns {
     
     var columnSumm: Int = 0
     
     for row in 0 ..< GameboardSize.rows {
     columnSumm += xoPositions[column][row].row
     }
     
     if columnSumm >= dummyXO + 1 && columnSumm <= dummyXO + GameboardSize.columns  {
     position = GameboardPosition(column: column, row: (columnSumm - dummyXO - GameboardSize.columns) * (-1), sing: O)
     return position
     }
     
     }
     
     
     // проходим по диогоналям
     
     for cell in 0 ..< GameboardSize.columns {
     diaSummLR += xoPositions[cell][cell].row
     }
     if diaSummLR >= dummyXO + 1 && diaSummLR <= dummyXO + GameboardSize.columns  {
     
     let cell = (diaSummLR - dummyXO - GameboardSize.columns) * (-1)
     position = GameboardPosition(column: cell, row: cell, sing: O)
     
     return position
     }
     
     for cell in 0 ..< GameboardSize.columns {
     diaSummRL += xoPositions[cell][GameboardSize.columns - 1 - cell].row
     }
     if diaSummRL >= dummyXO + 1 && diaSummRL <= dummyXO + GameboardSize.columns  {
     
     let cell = (diaSummRL - dummyXO - GameboardSize.columns) * (-1)
     
     position = GameboardPosition(column: diaSummRL - dummyXO - 1 , row: cell, sing: O)
     
     //position = GameboardPosition(column: GameboardSize.columns - 1 - cell , row: cell)
     
     return position
     }
     
     if self.gameboard.containsXO(at: position) {
     for column in 0 ..< GameboardSize.columns {
     for row in 0 ..< GameboardSize.rows {
     position = GameboardPosition(column: column, row: row, sing: O)
     if !self.gameboard.containsXO(at: position) {
     return position
     }
     }
     }
     }
     
     return position
     } */
    
    
    /*   // генерация хода компьютера - простое перечисление возможных комбинаций
     func generateCompStep(position: GameboardPosition) -> GameboardPosition {
     var compPosition = GameboardPosition(column: 1, row: 1)
     
     // анализ столбцов
     if (self.winPositions[0][0] == self.winPositions[0][1]) && (self.winPositions[0][0] != "_") && (self.winPositions[0][2] == "_") {
     compPosition = GameboardPosition(column: 0, row: 2)
     return compPosition
     
     }
     
     if (self.winPositions[0][0] == self.winPositions[0][2]) && (self.winPositions[0][0] != "_") && (self.winPositions[0][1] == "_") {
     compPosition = GameboardPosition(column: 0, row: 1)
     return compPosition
     
     }
     
     if (self.winPositions[0][1] == self.winPositions[0][2]) && (self.winPositions[0][1] != "_")  && (self.winPositions[0][0] == "_") {
     compPosition = GameboardPosition(column: 0, row: 0)
     return compPosition
     
     }
     
     if (self.winPositions[1][0] == self.winPositions[1][1]) && (self.winPositions[1][0] != "_")  && (self.winPositions[1][2] == "_") {
     compPosition = GameboardPosition(column: 1, row: 2)
     return compPosition
     
     }
     
     if (self.winPositions[1][0] == self.winPositions[1][2]) && (self.winPositions[1][0] != "_")  && (self.winPositions[1][1] == "_") {
     compPosition = GameboardPosition(column: 1, row: 1)
     return compPosition
     
     }
     
     if (self.winPositions[1][1] == self.winPositions[1][2]) && (self.winPositions[1][1] != "_")  && (self.winPositions[1][0] == "_") {
     compPosition = GameboardPosition(column: 1, row: 0)
     return compPosition
     
     }
     
     if (self.winPositions[2][0] == self.winPositions[2][1]) && (self.winPositions[2][0] != "_") && (self.winPositions[2][2] == "_") {
     compPosition = GameboardPosition(column: 2, row: 2)
     return compPosition
     
     }
     
     if (self.winPositions[2][0] == self.winPositions[2][2])  && (self.winPositions[2][0] != "_")  && (self.winPositions[2][1] == "_") {
     compPosition = GameboardPosition(column: 2, row: 1)
     return compPosition
     
     }
     
     if (self.winPositions[2][1] == self.winPositions[2][2]) && (self.winPositions[2][1] != "_")  && (self.winPositions[2][0] == "_") {
     compPosition = GameboardPosition(column: 2, row: 0)
     return compPosition
     
     }
     
     
     
     //анализ строк
     if (self.winPositions[0][0] == self.winPositions[1][0]) && (self.winPositions[0][0] != "_") && (self.winPositions[2][0] == "_") {
     compPosition = GameboardPosition(column: 2, row: 0)
     return compPosition
     
     }
     
     if (self.winPositions[0][0] == self.winPositions[2][0])  && (self.winPositions[0][0] != "_") && (self.winPositions[1][0] == "_") {
     compPosition = GameboardPosition(column: 1, row: 0)
     return compPosition
     
     }
     
     if (self.winPositions[1][0] == self.winPositions[2][0])  && (self.winPositions[1][0] != "_") && (self.winPositions[0][0] == "_") {
     compPosition = GameboardPosition(column: 0, row: 0)
     return compPosition
     
     }
     
     if (self.winPositions[0][1] == self.winPositions[1][1])  && (self.winPositions[0][1] != "_") && (self.winPositions[2][1] == "_") {
     compPosition = GameboardPosition(column: 2, row: 1)
     return compPosition
     
     }
     
     if (self.winPositions[0][1] == self.winPositions[2][1])  && (self.winPositions[0][1] != "_") && (self.winPositions[1][1] == "_") {
     compPosition = GameboardPosition(column: 1, row: 1)
     return compPosition
     
     }
     
     if (self.winPositions[1][1] == self.winPositions[2][1])  && (self.winPositions[1][1] != "_") && (self.winPositions[0][1] == "_"){
     compPosition = GameboardPosition(column: 0, row: 1)
     return compPosition
     
     }
     
     if (self.winPositions[0][2] == self.winPositions[1][2])  && (self.winPositions[0][2] != "_") && (self.winPositions[2][2] == "_") {
     compPosition = GameboardPosition(column: 2, row: 2)
     return compPosition
     
     }
     
     if (self.winPositions[0][2] == self.winPositions[2][2])  && (self.winPositions[0][2] != "_") && (self.winPositions[1][2] == "_") {
     compPosition = GameboardPosition(column: 1, row: 2)
     return compPosition
     
     }
     
     if (self.winPositions[1][2] == self.winPositions[2][2])  && (self.winPositions[1][2] != "_") && (self.winPositions[0][2] == "_") {
     compPosition = GameboardPosition(column: 0, row: 2)
     return compPosition
     }
     
     
     // анализ диогоналей
     if (self.winPositions[0][0] == self.winPositions[1][1])  && (self.winPositions[0][0] != "_") && (self.winPositions[2][2] == "_") {
     compPosition = GameboardPosition(column: 2, row: 2)
     return compPosition
     
     }
     
     if (self.winPositions[0][0] == self.winPositions[2][2])  && (self.winPositions[0][0] != "_") && (self.winPositions[1][1] == "_") {
     compPosition = GameboardPosition(column: 1, row: 1)
     return compPosition
     }
     
     if (self.winPositions[1][1] == self.winPositions[2][2])  && (self.winPositions[1][1] != "_")  && (self.winPositions[0][0] == "_") {
     compPosition = GameboardPosition(column: 0, row: 0)
     return compPosition
     }
     
     if (self.winPositions[2][0] == self.winPositions[1][1])  && (self.winPositions[2][0] != "_") && (self.winPositions[0][2] == "_") {
     compPosition = GameboardPosition(column: 0, row: 2)
     return compPosition
     
     }
     
     if (self.winPositions[2][0] == self.winPositions[0][2])  && (self.winPositions[2][0] != "_") && (self.winPositions[1][1] == "_") {
     compPosition = GameboardPosition(column: 1, row: 1)
     return compPosition
     
     }
     
     if (self.winPositions[1][1] == self.winPositions[0][2]) && (self.winPositions[1][1] != "_") && (self.winPositions[2][0] == "_") {
     compPosition = GameboardPosition(column: 2, row: 0)
     return compPosition
     
     }
     
     
     
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: 0, row: 0)
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: 0, row: 2)
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: 2, row: 2)
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: 2, row: 0)
     
     if  self.gameboard.containsXO(at: compPosition) {
     
     switch position.column {
     case 0:
     compPosition = GameboardPosition(column: position.column + 1, row: position.row)
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: position.column + 2, row: position.row)
     }
     
     case 1:
     compPosition = GameboardPosition(column: position.column + 1, row: position.row)
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: position.column - 1, row: position.row)
     }
     case 2:
     compPosition = GameboardPosition(column: position.column - 1, row: position.row)
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: position.column - 2, row: position.row)
     }
     default:
     break
     }
     
     if  self.gameboard.containsXO(at: compPosition) {
     
     switch position.row {
     case 0:
     compPosition = GameboardPosition(column: position.column, row: position.row + 1)
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: position.column, row: position.row + 2)
     }
     
     case 1:
     compPosition = GameboardPosition(column: position.column, row: position.row + 1)
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: position.column, row: position.row - 1)
     }
     case 2:
     compPosition = GameboardPosition(column: position.column, row: position.row - 1)
     if  self.gameboard.containsXO(at: compPosition) {
     compPosition = GameboardPosition(column: position.column, row: position.row - 2)
     }
     default:
     break
     }
     
     }
     }
     }
     }
     }
     }
     return compPosition
     } */
    
    //    func generateCompStepAI() -> GameboardPosition {
    //        var compPosition = GameboardPosition(column: 0, row: 0)
    //        for y in 0...2 {
    //        for x in 0...1 {
    //            if self.gameboard.contains(player: Player.first, at: GameboardPosition(column: y, row: x)) && self.gameboard.contains(player: Player.first, at: GameboardPosition(column: y, row: x+1)){
    //                print(GameboardPosition.self)
    //                compPosition = GameboardPosition(column: y, row: x)
    //            }
    //        }
    //
    //    }
    //        return compPosition
    //
    //    }
    
    
    
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
    
