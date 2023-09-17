import SwiftUI

enum HandShape: String, CaseIterable {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
    
    func beats(_ opponent: HandShape) -> Bool {
        switch (self, opponent) {
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            return true
        default:
            return false
        }
    }
}

struct RockPaperScissorsView: View {
    @State private var computerChoice = HandShape.allCases.randomElement()!
    @State private var resultString = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Rock, Paper, Scissors")
                .font(.largeTitle)
                .padding()
            
            Text("Computer chose: \(computerChoice.rawValue)")
                .font(.headline)
            
            Text(resultString)
                .font(.title)
                .padding()
            
            HStack {
                ForEach(HandShape.allCases, id: \.self) { shape in
                    Button(action: {
                        self.userTapped(shape)
                    }) {
                        Text(shape.rawValue)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            Button(action: resetGame) {
                Text("New Game")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    func userTapped(_ userChoice: HandShape) {
        if userChoice == computerChoice {
            resultString = "It's a draw!"
        } else if userChoice.beats(computerChoice) {
            resultString = "You win!"
        } else {
            resultString = "You lose!"
        }
    }
    
    func resetGame() {
        computerChoice = HandShape.allCases.randomElement()!
        resultString = ""
    }
}

struct ContentView: View {
    var body: some View {
        RockPaperScissorsView()
    }
}

struct RockPaperScissorsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
