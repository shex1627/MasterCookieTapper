import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("New Game") {
                    GameView(viewModel: viewModel)
                }
                .buttonStyle(.bordered)
                
                NavigationLink("Records") {
                    RecordsView(records: $viewModel.gameRecords)
                }
                .buttonStyle(.bordered)
                
                NavigationLink("Tutorial") {
                    TutorialView()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
