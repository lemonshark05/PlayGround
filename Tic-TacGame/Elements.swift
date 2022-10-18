//
//  Elements.swift
//  Tic-TacGame
//
//  Created by lemonshark on 2022/10/17.
//

import Foundation

let GMap = [ 0:"a", 1:"b", 2:"c", 3:"d", 4:"e", 5:"f", 6:"g", 7:"h", 8:"i", 9:"j", 10:"k", 11:"l", 12:"m", 13:"n", 14:"o", 15:"p"]

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
