//
//  GameView.swift
//  Tic-Tac-Toe
//
//  Created by zhanybek salgarin on 7/6/22.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Spacer()
                Text("tic-tac-toe")
                    .font(.system(size: 40, weight: .bold, design: .monospaced))
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 7) {
                    ForEach(0..<9) { i in
                        ZStack {
                            GameRectangleView(proxy: geometry)
                            
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indecator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameDisabled)
            .padding()
            .alert(viewModel.alertItem?.title ?? "", isPresented: $viewModel.didError) {
                Button(viewModel.alertItem?.button ?? "") {
                    viewModel.resetTheGame()
                }
            } message: {
                Text(viewModel.alertItem?.message ?? "")
            }
        }
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indecator: String {
        return player == .human ? "xmark" : "circle"
    }
    
    var tittleTextIndecator: String {
        return player == .human ? "Humans Turn" : "Cpmputers Turn"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct GameRectangleView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .foregroundColor(.blue).opacity(0.5)
            .frame(width: proxy.size.width/3 - 15, height: proxy.size.height/6 - 15)
    }
}

struct PlayerIndicator: View {
    
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
