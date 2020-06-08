//
//  MenuViewController.swift
//  XO-game
//
//  Created by Vitaly Khomatov on 21.05.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
        
    var playWithComputer: Bool = false
    var playFiveMarks: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBOutlet weak var PlayerSegmentControl: UISegmentedControl!
    
    @IBAction func PlayButtonPressed(_ sender: UIButton) {
        
        let player = PlayerSegmentControl.selectedSegmentIndex
        switch player {
        case 0:
            print("Второй игрок")
            playWithComputer = false
            playFiveMarks = false
        case 1:
            print("Компьютер")
            playWithComputer = true
            playFiveMarks = false
        case 2:
            print("Игрок 5 ходов")
            playWithComputer = false
            playFiveMarks = true
        default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Game" {
            
            guard let menuController = segue.source as? MenuViewController else { return }
            guard let gameController = segue.destination as? GameViewController else { return }
            
            gameController.playWithComputer = menuController.playWithComputer
            gameController.playFiveMarks = menuController.playFiveMarks

            
        }
    }

}


//    @IBAction func PlayerValueChanged(_ sender: UISegmentedControl) {
//        let player = sender.selectedSegmentIndex
//        switch player {
//        case 0:
//            print("Второй игрок")
//        case 1:
//            print("Компьютер")
//        default:
//            break
//        }
//    }
