//
//  ContentView.swift
//  SkySync
//
//  Created by Krish Shah on 9/16/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var manageMatch = ManageMatch()
    var body: some View {
        GameView(manageMatch: ManageMatch())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
