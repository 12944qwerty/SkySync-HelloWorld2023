//
//  GuesserGameView.swift
//  SkySync
//
//  Created by Christopher Lee on 9/16/23.
//

import SwiftUI

struct DrawerGameView: View {
    @ObservedObject var manageMatch: ManageMatch
    @State var drawingGuess = ""
    @State var enableErase = false
    
    func makeGuess() {
        // submit guess
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
                        DrawingView(enableErase: $enableErase, manageMatch: manageMatch)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 12))
                        VStack {
                            Spacer()
                        }
                        .padding()
                    }
                    pastGuesses
                    promptMessage
                }
                
                .padding(.horizontal, 10)
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
            HStack {
                Label("GUESS THE DRAWING:", systemImage: "exclamationmark.bubble.fill")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.black)
                Spacer()
            }
            HStack {
                TextField("Type your guess", text: $drawingGuess)
                    .padding()
                    .background(
                        Capsule(style: .circular)
                            .fill(Color.white))
                    .onSubmit(makeGuess)
                
                
                Button {
                    // Implement messaging functionality
                    //
                } label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color.black)
                }
            }

        }
        .frame(maxWidth: .infinity)
        .padding([.horizontal, .bottom], 10)
    }
}

struct DrawerGameView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerGameView(manageMatch: ManageMatch())
    }
}
