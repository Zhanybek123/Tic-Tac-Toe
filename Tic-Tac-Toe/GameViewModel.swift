//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by zhanybek salgarin on 8/7/22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameDisabled = false
    @Published var didError = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        
        //Human move processing
        if isSquareOccupied(in: moves, forIndex: position) {return}
        moves[position] = Move(player: .human, boardIndex: position)
        
        
        // check for win condition or draw
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertControl.humanWin
            didError = true
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertControl.draw
            didError = true
            return
        }
        
        isGameDisabled = true
        
        //Human move processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameDisabled = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertControl.computerWin
                didError = true
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertControl.draw
                didError = true
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        // If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2,], [3, 4, 5,], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap ({$0}).filter ({$0.player == .computer})
        let computerPositions = Set(computerMoves.map ({$0.boardIndex}))
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable {return winPositions.first!}
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap ({$0}).filter ({$0.player == .human})
        let humanPositions = Set(humanMoves.map ({$0.boardIndex}))
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable {return winPositions.first!}
            }
        }
        
        // If I can't block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        // If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in noves: [Move?]) -> Bool {
        
        let winPatterns: Set<Set<Int>> = [[0, 1, 2,], [3, 4, 5,], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap ({$0}).filter ({$0.player == player})
        let playerPosition = Set(playerMoves.map ({$0.boardIndex}))
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap({$0}).count == 9
    }
    
    func resetTheGame() {
        moves = Array(repeating: nil, count: 9)
    }
    
}
