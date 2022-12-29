//
//  ContentView.swift
//  Tic-TacGame
//
//  Created by lemonshark on 2022/10/17.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var vM = GameViewModel()
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Spacer()
                LazyVGrid(columns: vM.columns){
                    ForEach(0..<9) { i in
                        ZStack {
                            Rectangle()
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .foregroundColor(.orange).opacity(0.8).frame(width: geo.size.width/3-15,height: geo.size.width/3-15)
                            Image(systemName: vM.moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            vM.processPlayerMove(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(vM.isGameboardDisabled)
            .padding()
            .alert(item: $alertItem,content:{ alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle,action:{ vM.resetGame()}))
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
