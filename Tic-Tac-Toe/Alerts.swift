//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by zhanybek salgarin on 7/19/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    
    let id = UUID()
    var title: String
    var message: String
    var button: String
}

struct AlertControl {
    static let humanWin = AlertItem(title: "You Win!",
                             message: "You are so smart",
                             button: "hell Yeah")
    
    static let computerWin = AlertItem(title: "You Lost!",
                                message: "AI Won!",
                                button: "Try Again")
    
    static let draw = AlertItem(title: "Draw!",
                         message: "What a battle wits we have here",
                         button: "Rematch")
}
