//
//  TicTacToeView.swift
//  SkySync
//
//  Created by Caleb Buening on 9/16/23.
//

import Foundation
import SwiftUI

struct TicTacToeView: View {
    @ObservedObject var viewModel = TicTacToeViewModel()

    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<3) { row in
                HStack(spacing: 20) {
                    ForEach(0..<3) { column in
                        Button(action: {
                            viewModel.cellTapped(row: row, column: column)
                        }) {
                            Text(viewModel.board[row][column])
                                .frame(width: 100, height: 100)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .font(.system(size: 50))
                                .cornerRadius(10)
                        }
                    }
                }
            }

            Spacer().frame(height: 20)

            if let winner = viewModel.winner {
                Text("\(winner) Wins!")
                    .font(.title)
                    .foregroundColor(.green)
            } else {
                Text("Current Player: \(viewModel.currentPlayer)")
                    .font(.title)
            }
        }
        .padding()
    }
}
