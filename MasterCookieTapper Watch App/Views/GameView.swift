import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            // Main game content
            if let currentCookie = viewModel.cookieQueue.first {
                VStack {
                    Text(String(format: "Time: %.1f", viewModel.currentTime))
                        .font(.title2)
                    
                    Image(currentCookie ? "cookie" : "burnt_cookie")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .onTapGesture {
                            viewModel.handleCookieClick()
                        }
                        .onChange(of: viewModel.cookieQueue) { _ in
                            viewModel.startBadCookieTimer()
                        }
                    
                    if !currentCookie && viewModel.isBadCookieTimerActive {
                        Text("Cookie disappearing...")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        Text("Cookies: \(viewModel.config.totalCookies - viewModel.cookieQueue.count)/\(viewModel.config.totalCookies)")
                            .font(.caption)
                    }
                }
            } else {
                // Game over state with button at bottom
                VStack {
                    Spacer()
                    
                    Text("Game Over!")
                        .font(.title2)
                        .padding(.bottom, 4)
                    
                    Text(String(format: "Final Time: %.1f", viewModel.currentTime))
                        .font(.headline)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // Remove default button style and use custom background
                    Button(action: {
                        viewModel.startNewGame()
                    }) {
                        Text("Start New Game")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove default button styling
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }

            }
        }
        .padding()
        .onAppear {
            viewModel.startNewGame()
        }
    }
}