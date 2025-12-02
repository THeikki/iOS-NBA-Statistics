import Foundation

struct StatisticsModel: Codable {
    var playerName: String
    var position: String
    var age: Int
    var games: Int
    var offensiveRb: Int
    var defensiveRb: Int
    var assists: Int
    var steals: Int
    var blocks: Int
    var turnovers: Int
    var personalFouls: Int
    var points: Int
    var team: String
    var season: Int
}

class StatisticsViewModel {
    static func mapStatisticsFromDto(statisticsDto: StatisticsDto) -> StatisticsModel {
        let mappedStatistics = StatisticsModel(
            playerName: statisticsDto.playerName,
            position: statisticsDto.position,
            age: statisticsDto.age,
            games: statisticsDto.games,
            offensiveRb: statisticsDto.offensiveRb,
            defensiveRb: statisticsDto.defensiveRb,
            assists: statisticsDto.assists,
            steals: statisticsDto.steals,
            blocks: statisticsDto.blocks,
            turnovers: statisticsDto.turnovers,
            personalFouls: statisticsDto.personalFouls,
            points: statisticsDto.points,
            team: statisticsDto.team,
            season: statisticsDto.season
        )
        return mappedStatistics
    }
}
