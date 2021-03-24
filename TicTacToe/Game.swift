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
    
    enum PlayError: Error {
        case illegalMove
        case gameOver
    }
    
    mutating internal func restart() {
        // make new board
        // set game state to active, starting with x
        self.board = GameBoard()
        self.gameState = .active(.x)
    }
    
    mutating internal func makeMark(at coordinate: Coordinate, completion: @escaping (Result<Bool, PlayError>) -> Void) {
        guard case let GameState.active(player) = gameState else {
            completion(.failure(.gameOver))
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
            completion(.success(true))
        } catch {
            NSLog("Illegal move")
            completion(.failure(.illegalMove))
        }
    }
    
    private(set) var board: GameBoard
    
    internal var activePlayer: GameBoard.Mark = .x
    internal var gameIsOver: Bool
    internal var winningPlayer: GameBoard.Mark?
    internal var gameState = GameState.active(.x)
}


