import SwiftUI

struct TutorialView: View {
    @State private var currentPage = 0
    @Environment(\.dismiss) private var dismiss
    
    let tutorials = [
        "Welcome to Cookie Clicker!",
        "Click good cookies to increase your score",
        "Avoid bad cookies - they add time penalties",
        "Complete the game as fast as you can!"
    ]
    
    var body: some View {
        VStack {
            Text(tutorials[currentPage])
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack {
                Button("Exit") {
                    dismiss()
                }
                
                Spacer()
                
                if currentPage < tutorials.count - 1 {
                    Button("Next") {
                        currentPage += 1
                    }
                }
            }
            .padding()
        }
    }
}
