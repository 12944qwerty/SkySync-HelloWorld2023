import SwiftUI

struct Connect4View: View {
    @State private var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 7), count: 6)
    @State private var currentPlayer = 1
    @State private var winner: Int? = nil

    var body: some View {
        VStack {
            Text(winner != nil ? "Player \(winner!) wins!" : "Player \(currentPlayer)'s turn")
            ForEach(0..<6) { row in
                HStack {
                    ForEach(0..<7) { col in
                        Circle()
                            .foregroundColor(color(for: board[row][col]))
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                if winner == nil {
                                    drop(in: col)
                                }
                            }
                    }
                }
            }
            Spacer()
        }
        .padding()
    }

    private func color(for player: Int) -> Color {
        switch player {
        case 1: return .red
        case 2: return .yellow
        default: return .gray
        }
    }

    private func drop(in column: Int) {
        for row in stride(from: 5, through: 0, by: -1) {
            if board[row][column] == 0 {
                board[row][column] = currentPlayer
                if hasWinner(at: (row, column)) {
                    winner = currentPlayer
                } else {
                    currentPlayer = 3 - currentPlayer
                }
                break
            }
        }
    }

    private func hasWinner(at position: (Int, Int)) -> Bool {
        let directions: [(Int, Int)] = [(1, 0), (0, 1), (1, 1), (1, -1)]
        for direction in directions {
            if inLine(from: position, in: direction) + inLine(from: position, in: (-direction.0, -direction.1)) >= 3 {
                return true
            }
        }
        return false
    }

    private func inLine(from position: (Int, Int), in direction: (Int, Int)) -> Int {
        var count = 0
        var current = position

        while true {
            current.0 += direction.0
            current.1 += direction.1
            if current.0 < 0 || current.0 >= 6 || current.1 < 0 || current.1 >= 7 || board[current.0][current.1] != currentPlayer {
                break
            }
            count += 1
        }

        return count
    }
}

struct Connect4View_Previews: PreviewProvider {
    static var previews: some View {
        Connect4View()
    }
}
