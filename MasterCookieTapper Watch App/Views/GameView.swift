import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @GestureState private var isPressed: Bool = false
    @State private var isAnimating: Bool = false

    
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
                        .scaleEffect(isPressed || isAnimating ? 0.8 : 1.0)
                        .animation(.easeInOut(duration: 0.05), value: isPressed || isAnimating)
                        .gesture(
                            LongPressGesture(minimumDuration: 0.05)
                                .updating($isPressed) { _, state, _ in
                                    state = true
                                }
                                .onEnded { _ in
                                    handleCookiePress(isGoodCookie: currentCookie)
                                }
                        )
                    
                    if !currentCookie && viewModel.isBadCookieTimerActive {
                        Text("Watch out!")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        Text("Cookies: \(viewModel.config.totalCookies - viewModel.cookieQueue.count)/\(viewModel.config.totalCookies)")
                            .font(.caption)
                    }
                }.onChange(of: viewModel.cookieQueue) { _ in
                    viewModel.startBadCookieTimer()
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

    private func handleCookiePress(isGoodCookie: Bool) {
        // Play appropriate sound
        if isGoodCookie {
            SoundManager.shared.playGoodCookieSound()
        } else {
            SoundManager.shared.playBadCookieSound()
        }
        
        // Trigger click animation
        isAnimating = true
        
        // Handle cookie click in view model
        viewModel.handleCookieClick()
        
        // Reset animation after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            isAnimating = false
        }
    }
}
