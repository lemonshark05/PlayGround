//
//  ContentView.swift
//  Tic-TacGame
//
//  Created by lemonshark on 2022/10/17.
//

import SwiftUI

struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @State private var moves:[Move?] = Array(repeating: nil, count: 9)
    @State private var isHumanTurn = true
    @State private var isGameboardDisabled = false
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Spacer()
                LazyVGrid(columns: columns){
                    ForEach(0..<9) { i in
                        ZStack {
                            Rectangle()
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .foregroundColor(.orange).opacity(0.8).frame(width: geo.size.width/3-15,height: geo.size.width/3-15)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves,forIndex: i){ return }
                            moves[i] = Move(player: isHumanTurn ? .human:.computer, broadIndex: i)
                            isGameboardDisabled = true

                            if checkWinCondition(for: .human, in: moves) {
                                print("Human Wins")
                            }
                            
                            if checkForDraw(in: moves) {
                                print("draw")
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determinComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, broadIndex: computerPosition)
                                isGameboardDisabled = false
                                if checkWinCondition(for: .computer, in: moves) {
                                    print("Computer Wins")
                                }
                                
                                if checkForDraw(in: moves) {
                                    print("draw")
                                }
                                
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameboardDisabled)
            .padding()
        }
    }
    func isSquareOccupied(in moves:[Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.broadIndex == index})
    }
    
    func determinComputerMovePosition(in moves:[Move?]) -> Int{
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
