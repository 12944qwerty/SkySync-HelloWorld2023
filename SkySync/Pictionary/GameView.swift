//
//  GuesserGameView.swift
//  SkySync
//
//  Created by Christopher Lee on 9/16/23.
//

import SwiftUI
import PencilKit
import Photos

struct GameView: View {
   
    @State var drawingSize: CGSize = CGSize(width: 350, height: 80)
    @ObservedObject var manageMatch: ManageMatch
    @State var drawingGuess = ""
    @State var enableErase = false
    @State var isCountdownRunning = false // Tracks whether the countdown is running
    @State var timer: Timer? = nil
    
    // Function to start the countdown
        private func startCountdown() {
            if !isCountdownRunning {
                // Initialize the timer
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    manageMatch.timeRemaining -= 1 // Decrement the countdown time
                    
                    if manageMatch.timeRemaining <= 0 {
                        // Stop the timer when countdown reaches zero
                        stopCountdown()
                    }
                }
                isCountdownRunning = true
            }
        }
        
        // Function to stop the countdown
        private func stopCountdown() {
            timer?.invalidate()
            isCountdownRunning = false
        }
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                Image(manageMatch.currentlyDrawing ? "drawBg" : "drawBg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .scaleEffect(1)
                VStack {
                    topBar
                    ZStack {
                        DrawingView(enableErase: $enableErase, manageMatch: ManageMatch())
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 12))
                        VStack {
                            HStack {
                                Spacer()
                                if (manageMatch.currentlyDrawing) {
                                    Button {
                                        enableErase.toggle()
                                    } label: {
                                        Image(systemName: enableErase ? "eraser.fill" : "eraser")
                                            .font(.title)
                                            .foregroundColor(Color.black)
                                            .padding(.top, 10)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    pastGuesses
                    promptMessage
                }
                .padding(.horizontal, 30)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
    }
    
    var topBar: some View {
        ZStack {
            HStack {
                Label("Score: \(manageMatch.score)", systemImage: "plus.app.fill")
                    .bold()
                    .font(.title2)
                Spacer()

                Label("\(manageMatch.timeRemaining)", systemImage: "clock.fill")
                    .bold()
                    .font(.title2)
            }
        }
        .padding(.vertical, 15)
    }
    
    var pastGuesses: some View {
        ScrollView {
            // Put messages between the drawer and guesser. The guesser will type their guess and the drawer will either press "Correct or Incorrect" depending on the answer. The drawer's button press will appear as a message.
                HStack {
                    // Implement message functionality
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 1)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.5)).brightness(-0.2)
        .cornerRadius(20)
        .padding(.vertical)
        .padding(.bottom, 20)
    }
    
    var promptMessage: some View {
        VStack {
            Button() {
                // Button action
                // Send the picture to the guesser's viewer box.
        
                startCountdown()
            } label : {
                Label("SEND", systemImage: "paperplane.fill")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.blue)
                    .background(Color.white)
                    .cornerRadius(20)
            }
            .padding(.bottom, 10)
            
            
            HStack {
                Button() {
                    // Implement message functionality
                    manageMatch.score += 1
                    stopCountdown()
                    manageMatch.timeRemaining = 100
                } label : {
                    Label("CORRECT", systemImage: "checkmark.bubble.fill")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.green)
                        .background(Color.white)
                        .cornerRadius(20)
            }
                
                Button() {
                    // Button action
                    // Implement messaging functionality
                    manageMatch.score -= 1
                } label: {
                    Label("INCORRECT", systemImage: "xmark.app.fill")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.red)
                        .background(Color.white)
                        .cornerRadius(20)
                }
            }
        }
        .frame(maxWidth: .infinity)
      
    }
}

struct GuesserGameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(manageMatch: ManageMatch())
    }
}
