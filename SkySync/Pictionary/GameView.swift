//
//  GuesserGameView.swift
//  SkySync
//
//  Created by Christopher Lee on 9/16/23.
//

import SwiftUI

struct GameView: View {
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
                        DrawingView(manageMatch: manageMatch, enableErase: $enableErase)
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
            ForEach(manageMatch.pastGuesses) {guess in
                HStack {
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 1)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.5)).brightness(-0.2)
        .cornerRadius(20)
        .padding(.vertical)
        .padding(.bottom, 40)
    }
    
    var promptMessage: some View {
        VStack {
            Button() {
                // Button action
            } label : {
                Label("SEND", systemImage: "paperplane.fill")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.blue)
            }
            
            Button() {
                // Button action
            } label : {
                Label("CORRECT", systemImage: "checkmark.bubble.fill")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.green)
            }
            
            Button() {
                // Button action
            } label: {
                Label("INCORRECT", systemImage: "xmark.app.fill")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color.red)
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
