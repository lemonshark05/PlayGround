//
//  GameViewModel.swift
//  Tic-TacGame
//
//  Created by lemonshark on 2022/12/28.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @Published var moves:[Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves,forIndex: position){ return }
        moves[position] = Move(player: .human, broadIndex: position)
//        isGameboardDisabled = true

        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determinComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, broadIndex: computerPosition)
            isGameboardDisabled = false
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.AiWin
                return
            }
            
            if checkForDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves:[Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.broadIndex == index})
    }
    
    func determinComputerMovePosition(in moves:[Move?]) -> Int{
        let winPatters: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        //ai win
        let aiMoves = moves.compactMap{$0}.filter {$0.player == .computer}
        let aiPositions = Set(aiMoves.map{$0.broadIndex})
        
        for pattern in winPatters {
            let winPosition = pattern.subtracting(aiPositions)
            if winPosition.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvaiable{return winPosition.first! }
            }
        }
        //human win
        let humanMoves = moves.compactMap{$0}.filter {$0.player == .human}
        let humanPositions = Set(aiMoves.map{$0.broadIndex})
        
        for pattern in winPatters {
            let winPosition = pattern.subtracting(humanPositions)
            if winPosition.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPosition.first!)
                if isAvaiable{return winPosition.first! }
            }
        }
        //AI can't block
        let centerSqure = 4
        if !isSquareOccupied(in: moves, forIndex: centerSqure) {
            return centerSqure
        }
            
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool{
        let winPatters: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        let playerMoves = moves.compactMap{$0}.filter {$0.player==player}
        let playerPositions = Set(playerMoves.map{$0.broadIndex})
        for pattern in winPatters where pattern.isSubset(of: playerPositions){
            return true
        }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap{ $0 }.count == 9
    }
    func resetGame() {
        moves = Array(repeating: nil, count: 9);
    }
}
