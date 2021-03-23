//
//  Game.swift
//  TicTacToe
//
//  Created by Lorenzo on 3/23/21.
//  Copyright © 2021 Lambda School. All rights reserved.
//

import Foundation

struct Game {
    
    enum GameState: Equatable {
        case active(GameBoard.Mark) // Active player
        case cat
        case won(GameBoard.Mark) // Winning player
    }
    mutating internal func restart() {
        // make new board
        // set game state to active, starting with x
        self.board = GameBoard()
        self.gameState = .active(.x)
    }
    mutating internal func makeMark(at coordinate: Coordinate) throws {
        guard case let GameState.active(player) = gameState else {
            NSLog("Game is over")
            return
        }
        
        do {
            try board.place(mark: player, on: coordinate)
            if game(board: board, isWonBy: player) {
                gameState = .won(player)
                self.winningPlayer = player
                self.gameIsOver = true
            } else if board.isFull {
                gameState = .cat
                self.gameIsOver = true
            } else {
                let newPlayer = player == .x ? GameBoard.Mark.o : GameBoard.Mark.x
                gameState = .active(newPlayer)
            }
        } catch {
            NSLog("Illegal move")
        }
    }
    
    private(set) var board: GameBoard
    
    internal var activePlayer: GameBoard.Mark = .x
    internal var gameIsOver: Bool
    internal var winningPlayer: GameBoard.Mark?
    internal var gameState = GameState.active(.x)
}


