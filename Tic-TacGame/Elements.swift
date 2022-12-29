//
//  Elements.swift
//  Tic-TacGame
//
//  Created by lemonshark on 2022/10/17.
//

import Foundation

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let broadIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark":"circle"
    }
}
