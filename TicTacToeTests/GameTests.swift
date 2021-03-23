//
//  GameTests.swift
//  TicTacToeTests
//
//  Created by Lorenzo on 3/23/21.
//  Copyright © 2021 Lambda School. All rights reserved.
//

import XCTest
@testable import TicTacToe

class GameTests: XCTestCase {

    func testRestart() {
        // board should be a new, empty board
        var game = Game(board: GameBoard(), gameIsOver: false)
        game.gameState = .active(.x)
        
        XCTAssertFalse(game.board.isFull)
        XCTAssertFalse(game.gameIsOver)
        XCTAssertEqual(game.gameState,.active(.x))
        
    }
    
    func testMakeMark() {
        // first check that it's nil
        var game = Game(board: GameBoard(), gameIsOver: false)
        let coordinate1 = (0, 0)
        XCTAssertNil(game.board[coordinate1])
        // run the function
        try! game.makeMark(at: coordinate1)
        // check that it's no longer nil
        XCTAssertNotNil(game.board[coordinate1])
        XCTAssertEqual(game.board[coordinate1], .x)
        
        
        // make sure o goes next
        let coordinate2 = (0, 1)
        XCTAssertNil(game.board[coordinate2])
        try! game.makeMark(at: coordinate2)
        XCTAssertEqual(game.board[coordinate2], .o)
        
    }
    
    func testActivePlayer() {
        var game = Game(board: GameBoard(), gameIsOver: false)
        // x starts each game
        XCTAssertEqual(game.activePlayer, .x)
        
        // Game starts
        game.gameState = .active(.x)
            
        // State is unchanged by making game active
        XCTAssertEqual(game.activePlayer, .x)
    }
    
    func testXWin() {
        var game = Game(board: GameBoard(), gameIsOver: false)
        
        /*
        x o -
        x o -
        x - -
        */
        // makeMark will have to switch between active players
        try! game.makeMark(at: (0, 0))
        try! game.makeMark(at: (1, 0))
        try! game.makeMark(at: (0, 1))
        try! game.makeMark(at: (1, 1))
        try! game.makeMark(at: (0, 2))
        
        XCTAssertEqual(game.winningPlayer, .x)
        XCTAssert(game.gameIsOver)
        XCTAssertEqual(game.gameState, .won(.x))
    }
    
    func testOWin() {
        var game = Game(board: GameBoard(), gameIsOver: false)
        
        
        try! game.makeMark(at: (1, 0))
        try! game.makeMark(at: (0, 0))
        try! game.makeMark(at: (1, 1))
        try! game.makeMark(at: (0, 1))
        try! game.makeMark(at: (2, 1))
        try! game.makeMark(at: (0, 2))
        
        /*
        o x -
        o x x
        o  -
         */
        
        XCTAssertEqual(game.winningPlayer, .o)
        XCTAssert(game.gameIsOver)
        XCTAssertEqual(game.gameState, .won(.o))
    }
    
    func testIncomplete() {
        var game = Game(board: GameBoard(), gameIsOver: false)
        
        try! game.makeMark(at: (0, 0))
        try! game.makeMark(at: (1, 0))
        try! game.makeMark(at: (0, 1))
        try! game.makeMark(at: (1, 1))
        
        XCTAssertFalse(game.gameIsOver)
        XCTAssertNotEqual(game.winningPlayer, .x)
        XCTAssertNotEqual(game.winningPlayer, .o)
    }
}
