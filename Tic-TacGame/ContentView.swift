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
                            isHumanTurn.toggle()
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
    func isSquareOccupied(in moves:[Move?], forIndex index: Int) -> Bool{
        return moves.contains(where: {$0?.broadIndex == index})
    }
    
    func determinComputerMovePosition(in moves:[Move?] -> Int){
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: Int){
            var movePosition  = Int.random(in: 0..<9)
        }
        return movePosition
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
