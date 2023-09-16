//
//  ManageMatch.swift
//  SkySync
//
//  Created by Christopher Lee on 9/16/23.
//

import Foundation
import GameKit
import PencilKit

class ManageMatch: ObservableObject {
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var currentlyDrawing = true
    @Published var pastGuesses = [PastGuess]()
    @Published var score = 0
    @Published var timeRemaining = 100
    
    var localPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    
    

    
}
