//
//  Game.swift
//  SkySync
//
//  Created by Christopher Lee on 9/16/23.
//

import Foundation


struct PastGuess: Identifiable {
    var id: UUID
    var message: String
    var correct: Bool
}

let maxtimeremaining = 100
