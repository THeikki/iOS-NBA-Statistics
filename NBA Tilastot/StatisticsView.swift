import SwiftUI

struct StatisticsView: View {
    var statistics: StatisticsModel
    var isLoading: Bool
    
    var body: some View {
        ZStack {
            if(isLoading) {
                ProgressView()
            }
            else if(!isLoading && statistics.playerName == "") {
                Text("Tilastoja ei löytynyt!")
            }
            else {
                VStack {
                    Text("Tilastot").font(.title)
                    Text(String(statistics.season))
                    Spacer()
                    VStack {
                        HStack {
                            Text("Nimi:")
                            Text(statistics.playerName)
                        }
                        HStack {
                            Text("Ikä:")
                            Text(String(statistics.age))
                        }
                        HStack {
                            Text("Joukkue:")
                            Text(statistics.team)
                        }
                        HStack {
                            Text("Pelipaikka:")
                            Text(statistics.position)
                        }
                        HStack {
                            Text("Ottelut:")
                            Text(String(statistics.games))
                        }
                        HStack {
                            Text("Hyökkäyslevypallot:")
                            Text(String(statistics.offensiveRb))
                        }
                        HStack {
                            Text("Puolustuslevypallot:")
                            Text(String(statistics.defensiveRb))
                        }
                        HStack {
                            Text("Syötöt:")
                            Text(String(statistics.assists))
                        }
                        HStack {
                            Text("Pallon riistot:")
                            Text(String(statistics.steals))
                        }
                        HStack {
                            Text("Blokkaukset:")
                            Text(String(statistics.blocks))
                        }
                    }
                    VStack {
                        HStack {
                            Text("Pallon menetykset:")
                            Text(String(statistics.turnovers))
                        }
                        HStack {
                            Text("Virheet:")
                            Text(String(statistics.personalFouls))
                        }
                        HStack {
                            Text("Pisteet:")
                            Text(String(statistics.points))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var statistics = StatisticsModel(
        playerName: "",
        position: "",
        age: -1,
        games: -1,
        offensiveRb: -1,
        defensiveRb: -1,
        assists: -1,
        steals: -1,
        blocks: -1,
        turnovers: -1,
        personalFouls: -1,
        points: -1,
        team: "",
        season: -1
    )
    static var isLoading = true
    static var previews: some View {
        StatisticsView(statistics: statistics, isLoading: isLoading)
    }
}
