import SwiftUI

class GameViewModel: ObservableObject {
    @Published var cookieQueue: [Bool] = [] // true = good cookie, false = bad cookie
    @Published var currentTime: TimeInterval = 0
    @Published var isGameActive: Bool = false
    @Published var gameRecords: [GameRecord] = []
    
    private var timer: Timer?
    private let config: GameConfig
    
    init(config: GameConfig = GameConfig()) {
        self.config = config
        loadRecords()
    }
    
    func startNewGame() {
        cookieQueue = generateCookieQueue()
        currentTime = 0
        isGameActive = true
        startTimer()
    }
    
    private func generateCookieQueue() -> [Bool] {
        let badCookies = max(1, Int(Double(config.totalCookies) * config.badCookieRatio))
        var queue = Array(repeating: true, count: config.totalCookies - badCookies)
        queue.append(contentsOf: Array(repeating: false, count: badCookies))
        return queue.shuffled()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.currentTime += 0.1
        }
    }
    
    func handleCookieClick() {
        guard !cookieQueue.isEmpty else { return }
        
        let isBadCookie = !cookieQueue[0]
        cookieQueue.removeFirst()
        
        if isBadCookie {
            currentTime += config.penaltySeconds
        }
        
        if cookieQueue.isEmpty {
            endGame()
        }
    }
    
    private func endGame() {
        timer?.invalidate()
        timer = nil
        isGameActive = false
        
        let record = GameRecord(id: UUID(), completionTime: currentTime, date: Date())
        gameRecords.append(record)
        gameRecords.sort { $0.completionTime < $1.completionTime }
        if gameRecords.count > 10 {
            gameRecords = Array(gameRecords.prefix(10))
        }
        saveRecords()
    }
    
    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: "gameRecords"),
           let records = try? JSONDecoder().decode([GameRecord].self, from: data) {
            gameRecords = records
        }
    }
    
    private func saveRecords() {
        if let data = try? JSONEncoder().encode(gameRecords) {
            UserDefaults.standard.set(data, forKey: "gameRecords")
        }
    }
}