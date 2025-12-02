import Foundation

struct StatisticsDto: Codable {
    var playerId: String
    var playerName: String
    var position: String
    var age: Int
    var games: Int
    var gamesStarted: Int
    var minutesPg: Int
    var fieldGoals: Int
    var fieldAttempts: Int
    var fieldPercent: Float
    var threeFg: Int
    var threeAttempts: Int
    var threePercent: Float
    var twoFg: Int
    var twoAttempts: Int
    var twoPercent: Float
    var effectFgPercent: Float
    var ft: Int
    var ftAttempts: Int
    var ftPercent: Float
    var offensiveRb: Int
    var defensiveRb: Int
    var totalRb: Int
    var assists: Int
    var steals: Int
    var blocks: Int
    var turnovers: Int
    var personalFouls: Int
    var points: Int
    var team: String
    var season: Int
    var isPlayoff: Bool
}

struct Pagination: Codable {
    var total: Int
    var page: Int
    var pageSize: Int
    var pages: Int
}

struct ResponseDto: Codable {
    var data: [StatisticsDto]
    var pagination: Pagination
}


