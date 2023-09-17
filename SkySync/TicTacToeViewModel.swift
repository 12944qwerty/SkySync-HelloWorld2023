// TicTacToeViewModel.swift

import Foundation
import Combine

class TicTacToeViewModel: ObservableObject {
    @Published var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @Published var currentPlayer: String = "X"
    @Published var winner: String? = nil

    func cellTapped(row: Int, column: Int) {
        if board[row][column] == "" && winner == nil {
            board[row][column] = currentPlayer
            if checkWinner(player: currentPlayer) {
                winner = currentPlayer
            } else {
                currentPlayer = currentPlayer == "X" ? "O" : "X"
            }
        }
    }

    private func checkWinner(player: String) -> Bool {
        // Check rows and columns
        for i in 0..<3 {
            if board[i].allSatisfy({ $0 == player }) || (0..<3).allSatisfy({ board[$0][i] == player }) {
                return true
            }
        }
        
        // Check diagonals
        if (0..<3).allSatisfy({ board[$0][$0] == player }) || (0..<3).allSatisfy({ board[$0][2 - $0] == player }) {
            return true
        }
        
        return false
    }
}
