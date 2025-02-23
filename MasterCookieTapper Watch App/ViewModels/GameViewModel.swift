import SwiftUI

class GameViewModel: ObservableObject {
    @Published var cookieQueue: [Bool] = []
    @Published var currentTime: TimeInterval = 0
    @Published var isGameActive: Bool = false
    @Published var gameRecords: [GameRecord] = []
    @Published var isBadCookieTimerActive = false
    
    private var gameTimer: Timer?
    private var badCookieTimer: Timer?
    let config: GameConfig
    
    init(config: GameConfig = GameConfig()) {
        self.config = config
        loadRecords()
    }
    
    func startNewGame() {
        cookieQueue = generateCookieQueue()
        currentTime = 0
        isGameActive = true
        startGameTimer()
    }
    
    private func generateCookieQueue() -> [Bool] {
        let badCookies = Int(Double(config.totalCookies) * config.badCookieRatio)
        var queue = Array(repeating: true, count: config.totalCookies - badCookies)
        queue.append(contentsOf: Array(repeating: false, count: badCookies))
        
        // Shuffle all cookies except the first one
        if queue.count > 1 {
            let firstCookie = true // Force first cookie to be good
            var remainingCookies = Array(queue.dropFirst()).shuffled()
            queue = [firstCookie] + remainingCookies
        }
        
        return queue
    }
    
    private func startGameTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.currentTime += 0.1
        }
    }
    
    func startBadCookieTimer() {
        // Only start the timer if the current cookie is bad
        guard !cookieQueue.isEmpty && !cookieQueue[0] else { return }
        
        isBadCookieTimerActive = true
        badCookieTimer?.invalidate()
        
        badCookieTimer = Timer.scheduledTimer(withTimeInterval: config.badCookieDisappearTime, repeats: false) { [weak self] _ in
            self?.handleBadCookieTimeout()
        }
    }
    
    private func handleBadCookieTimeout() {
        guard !cookieQueue.isEmpty && !cookieQueue[0] else { return }
        
        // Remove the bad cookie and add penalty
        cookieQueue.removeFirst()
        currentTime += config.penaltySeconds
        isBadCookieTimerActive = false
        
        if cookieQueue.isEmpty {
            endGame()
        }
    }
    
    func handleCookieClick() {
        guard !cookieQueue.isEmpty else { return }
        
        let isBadCookie = !cookieQueue[0]
        
        if isBadCookie {
            // Don't remove bad cookie on click, just apply penalty
            currentTime += config.penaltySeconds
        } else {
            // Remove good cookie and continue
            cookieQueue.removeFirst()
        }
        
        if cookieQueue.isEmpty {
            endGame()
        }
    }
    
    private func endGame() {
        gameTimer?.invalidate()
        gameTimer = nil
        badCookieTimer?.invalidate()
        badCookieTimer = nil
        isGameActive = false
        isBadCookieTimerActive = false
        
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

    // Method to delete a specific record
    func deleteRecord(_ record: GameRecord) {
        if let index = gameRecords.firstIndex(where: { $0.id == record.id }) {
            gameRecords.remove(at: index)
            saveRecords() // Assuming you have a method to save records
        }
    }
    
    // Method to reset all records
    func resetAllRecords() {
        gameRecords.removeAll()
        saveRecords() // Assuming you have a method to save records
    }
}
