//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Andrew R Madsen on 9/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, BoardViewControllerDelegate {
    
    // MARK: - Properties
    
    var game = Game(board: GameBoard(), gameIsOver: false) {
        didSet {
            updateViews()
            boardViewController.board = game.board
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    

    
    @IBAction func restartGame(_ sender: Any) {
        game.restart()
    }
    
    // MARK: - BoardViewControllerDelegate
    
    private var boardViewController: BoardViewController! {
         willSet {
             boardViewController?.delegate = nil
         }
         didSet {
             boardViewController?.board = game.board
             boardViewController?.delegate = self
         }
     }
    
    func boardViewController(_ boardViewController: BoardViewController, markWasMadeAt coordinate: Coordinate) {
        game.makeMark(at: coordinate, completion: { (result) in
            do { try result.get() }
            catch {
                if let error = error as? Game.PlayError {
                    switch error {
                    case .illegalMove:
                        DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Illegal Move",
                                                      message: "Square already in use",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                       }
                    case .gameOver:
                        print("game over!!!")
                        DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Game Over",
                                                      message: "Please start a new game",
                                                      preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: {alert in
                                self.game.restart()
                            }))
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                       }
                    }
                }
            }
        })
    }
    
    @objc func restartHandler() {
        game.restart()
    }
    
    // MARK: - Private
    
    private func updateViews() {
        guard isViewLoaded else { return }
  
        switch game.gameState {
        case let .active(player):
            statusLabel.text = "Player \(player.stringValue)'s turn"
        case .cat:
            statusLabel.text = "Cat's game!"
        case let .won(player):
            statusLabel.text = "Player \(player.stringValue) won!"
        default:
            break
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "EmbedBoard" {
             boardViewController = segue.destination as? BoardViewController
         }
     }
}
