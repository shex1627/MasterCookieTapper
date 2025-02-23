import SwiftUI

struct TutorialView: View {
    @State private var currentPage = 0
    @Environment(\.dismiss) private var dismiss
    
    let config: GameConfig
    
    init(config: GameConfig = GameConfig()) {
        self.config = config
    }
    
    var tutorialContent: [(title: String, description: String)] {
        [
            (
                title: "Welcome!",
                description: "Welcome to Cookie Clicker! Click through cookies as fast as you can."
            ),
            (
                title: "Good Cookies",
                description: "Tap good cookies quickly to progress through the game."
            ),
            (
                title: "Bad Cookies",
                description: "Watch out for burnt cookies! They add a \(Int(config.penaltySeconds)) second penalty."
            ),
            (
                title: "Auto-Disappear",
                description: "Bad cookies disappear in \(String(Int(config.badCookieDisappearTime))) seconds automatically."
            ),
            (
                title: "Goal",
                description: "Complete all \(config.totalCookies) cookies as fast as you can! Only \(Int(config.badCookieRatio * 100))% are bad cookies."
            )
        ]
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Progress indicators
            // HStack(spacing: 4) {
            //     ForEach(0..<tutorialContent.count, id: \.self) { index in
            //         Circle()
            //             .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.3))
            //             .frame(width: 8, height: 8)
            //     }
            // }
            // .padding(.top, 8)
            
            // Spacer()
            
            // Tutorial content
            VStack(spacing: 8) {
                Text(tutorialContent[currentPage].title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(tutorialContent[currentPage].description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }
            
            // Navigation buttons
            HStack {
                Button("Exit") {
                    dismiss()
                }
                .foregroundColor(.red)
                
                // Spacer()
                
                if currentPage < tutorialContent.count - 1 {
                    Button("Next") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                    .foregroundColor(.blue)
                } else {
                    Button("Start") {
                        dismiss()
                    }
                    .foregroundColor(.green)
                }
            }
            .padding()
        }
        .padding(.vertical)
    }
}

// Preview provider for SwiftUI canvas
#Preview {
    TutorialView(config: GameConfig(
        totalCookies: 10,
        badCookieRatio: 0.1,
        penaltySeconds: 2.0,
        badCookieDisappearTime: 1.0
    ))
}
