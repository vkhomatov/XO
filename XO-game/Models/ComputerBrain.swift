//
//  ComputerBrain.swift
//  XO-game
//
//  Created by Vitaly Khomatov on 30.05.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

// анализ предыдущих ходов и генерация хода компьютера
class ComputerBrain {
    
    func generatePosition(xoPositions: [[GameboardPosition]], gameboard: Gameboard, X: Int, O: Int) -> GameboardPosition {
        
        // генерируем рэндомный ход
        var position = GameboardPosition(column: Int.random(in: 0 ..< GameboardSize.columns), row: Int.random(in: 0 ..< GameboardSize.rows), sing: O)
        
        // внутренние свойства
        var singsLR = [Int]()
        var singsRL = [Int]()
        var columnX = [Int]()
        var columnO = [Int]()
        var rowX = [Int]()
        var rowO = [Int]()
        var winX: Bool = false
        var winO: Bool = false
        var cellXRow: Int = 0
        var cellXColumn: Int = 0
        var cellORow: Int = 0
        var cellOColumn: Int = 0
        
        for _ in 0 ..< GameboardSize.rows {
            singsLR.append(0)
            singsRL.append(0)
        }
        
        // проходим по строчкам и проверяем предвыигрышную комбинацию в строках
        for row in 0 ..< GameboardSize.rows {
            
            var sings = [Int]()
            for _ in 0 ..< GameboardSize.rows { sings.append(0) }
            
            for column in 0 ..< GameboardSize.columns {
                if let sing = xoPositions[column][row].sing {
                    sings[column] = sing
                }
            }
            
            switch sings.reduce(0, +) {
            case 2*X:
                winX = true
                rowX = sings
                cellXRow = row
            case 2*O:
                winO = true
                rowO = sings
                cellORow = row
            default:
                break
            }
            
        }
        
        // выбираем из возможных комбинаций два крестика или два нолика в одной строке
        if winX && !winO {
            if let cell = rowX.firstIndex(of: 0) {
                position = GameboardPosition(column: cell, row: cellXRow, sing: O)
                return position
            }
        }
        
        if winO || (winX && winO) {
            if let cell = rowO.firstIndex(of: 0) {
                position = GameboardPosition(column: cell, row: cellORow, sing: O)
                return position
            }
        }
        
        
        // проходим по столбцам и проверяем предвыигрышную комбинацию в столбцах
        for column in 0 ..< GameboardSize.columns {
            
            var sings = [Int]()
            for _ in 0 ..< GameboardSize.columns { sings.append(0) }
            
            for row in 0 ..< GameboardSize.rows {
                if let sing = xoPositions[column][row].sing {
                    sings[row] = sing
                }
            }
            
            switch sings.reduce(0, +) {
            case 2*X:
                winX = true
                columnX = sings
                cellXColumn = column
            case 2*O:
                winO = true
                columnO = sings
                cellOColumn = column
            default:
                break
            }
     
        }
        
        // выбираем из возможных комбинаций - два крестика или два нолика в одном столбце
        if winX && !winO {
            if let cell = columnX.firstIndex(of: 0) {
                position = GameboardPosition(column: cellXColumn, row: cell, sing: O)
                return position
            }
        }
        
        if winO || (winX && winO) {
            if let cell = columnO.firstIndex(of: 0) {
                position = GameboardPosition(column: cellOColumn, row: cell, sing: O)
                return position
            }
        }
        
        
        
        // проходим по диогонали L - R и проверяем предвыигрышную комбинацию
        for cell in 0 ..< GameboardSize.columns { if let sing = xoPositions[cell][cell].sing { singsLR[cell] = sing } }
        
        let summLR = singsLR.reduce(0, +)
        if summLR == 2*X || summLR == 2*O {
            if let cell = singsLR.firstIndex(of: 0) {
                position = GameboardPosition(column: cell, row: cell, sing: O)
                return position
            }
        }
        
        // проходим по диогонали R - L и проверяем предвыигрышную комбинацию
        for cell in 0 ..< GameboardSize.columns { if let sing = xoPositions[cell][GameboardSize.columns - 1 - cell].sing { singsRL[cell] = sing } }
        
        let summRL = singsRL.reduce(0, +)
        if summRL == 2*X || summRL == 2*O {
            if let cell = singsRL.firstIndex(of: 0) {
                position = GameboardPosition(column: cell, row: GameboardSize.columns - 1 - cell, sing: O)
                return position
            }
        }
        
        // если предвыигрышных комбинаций не обнаружено - ставим в любой из углов или в первую свободную клетку на доске
        if gameboard.containsXO(at: position) {
            position = GameboardPosition(column: 0, row: 0)
            if  gameboard.containsXO(at: position) {
                position = GameboardPosition(column: 0, row: GameboardSize.rows - 1)
                if  gameboard.containsXO(at: position) {
                    position = GameboardPosition(column: GameboardSize.columns - 1, row: GameboardSize.rows - 1)
                    if  gameboard.containsXO(at: position) {
                        position = GameboardPosition(column: GameboardSize.columns - 1, row: 0)
                        if  gameboard.containsXO(at: position) {
                            for column in 0 ..< GameboardSize.columns {
                                for row in 0 ..< GameboardSize.rows {
                                    position = GameboardPosition(column: column, row: row)
                                    if !gameboard.containsXO(at: position) {
                                        return position
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    return position
    }
}
