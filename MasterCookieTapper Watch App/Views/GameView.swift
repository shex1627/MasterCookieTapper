import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            if let currentCookie = viewModel.cookieQueue.first {
                Text(String(format: "Time: %.1f", viewModel.currentTime))
                    .font(.title2)
                
                Image(currentCookie ? "cookie" : "burnt_cookie")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .onTapGesture {
                        viewModel.handleCookieClick()
                    }
                
                Text("Remaining: \(viewModel.cookieQueue.count)")
                    .font(.caption)
            } else {
                Button("Start New Game") {
                    viewModel.startNewGame()
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.startNewGame()
        }
    }
}