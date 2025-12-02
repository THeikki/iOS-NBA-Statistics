import Foundation

class WebApiRequest {
    static var response = [StatisticsDto]()
    static func fetchStatistics(season: String, team: String) async {
        let url = URL(string: "https://api.server.nbaapi.com/api/playertotals?season=\(season)&team=\(team)&page=1&pageSize=35&isPlayoff=False")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(ResponseDto.self, from: data)
            self.response = response.data
        } catch {
            print("Tapahtui virhe: \(error)")
        }
    }
}
