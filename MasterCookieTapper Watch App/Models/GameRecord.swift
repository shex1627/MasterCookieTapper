import Foundation

struct GameRecord: Identifiable, Codable {
    let id: UUID
    let completionTime: TimeInterval
    let date: Date
}