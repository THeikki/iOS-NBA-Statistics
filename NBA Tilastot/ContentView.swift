//
//  ContentView.swift
//  NBA Tilastot
//
//  Created by Heikki Törmänen @2025
//

import SwiftUI

struct ContentView: View {
    struct Team: Hashable {
        var abbreviation: String
        var name: String
    }
    let filterOptions: [String] = [
        "-Valitse suodatustapa-",
        "Vähiten pisteitä",
        "Eniten pisteitä"
    ]
    let seasons: [String] = [
        "-Valitse kausi-",
        "2025",
        "2024",
        "2023",
        "2022",
        "2021",
        "2020",
        "2019",
        "2018",
        "2017",
        "2016",
        "2015",
    ]
    let teams: [Team] = [
        Team(abbreviation: "", name: "-Valitse joukkue-"),
        Team(abbreviation: "ATL", name: "Atlanta Hawks"),
        Team(abbreviation: "BOS", name: "Boston Celtics"),
        Team(abbreviation: "BRK", name: "Brooklyn Nets"),
        Team(abbreviation: "CHO", name: "Charlotte Hornets"),
        Team(abbreviation: "CHI", name: "Chicago Bulls"),
        Team(abbreviation: "CLE", name: "Cleveland Cavaliers"),
        Team(abbreviation: "DAL", name: "Dallas Mavericks"),
        Team(abbreviation: "DEN", name: "Denver Nuggets"),
        Team(abbreviation: "DET", name: "Detroit Pistons"),
        Team(abbreviation: "GSW", name: "Golden State Warriors"),
        Team(abbreviation: "HOU", name: "Houston Rockets"),
        Team(abbreviation: "IND", name: "Indiana Pacers"),
        Team(abbreviation: "LAC", name: "Los Angeles Clippers"),
        Team(abbreviation: "LAL", name: "Los Angeles Lakers"),
        Team(abbreviation: "MEM", name: "Memphis Grizzlies"),
        Team(abbreviation: "MIA", name: "Miami Heat"),
        Team(abbreviation: "MIL", name: "Milwaukee Bucks"),
        Team(abbreviation: "MIN", name: "Minnesota Timberwolves"),
        Team(abbreviation: "NOP", name: "New Orleans Pelicans"),
        Team(abbreviation: "NYK", name: "New York Knicks"),
        Team(abbreviation: "OKC", name: "Oklahoma City Thunder"),
        Team(abbreviation: "ORL", name: "Orlando Magic Hawks"),
        Team(abbreviation: "PHI", name: "Philadelphia 76ers"),
        Team(abbreviation: "PHO", name: "Phoenix Suns"),
        Team(abbreviation: "POR", name: "Portland Trail Blazers"),
        Team(abbreviation: "SAC", name: "Sacramento Kings"),
        Team(abbreviation: "TOR", name: "Toronto Raptors"),
        Team(abbreviation: "UTA", name: "Utah Jazz"),
        Team(abbreviation: "WAS", name: "Washington Wizards"),
    ]
    
    @State private var selectedSeason = ""
    @State private var selectedTeam: Team = Team(abbreviation: "", name: "")
    @State private var selectedFilter = ""
    @State private var isLoading = true
    @State private var statistics = StatisticsModel(
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
    @State private var linkIsActive = false
    
    var body: some View {
        NavigationView {
            ZStack() {
                VStack {
                    Text("NBA Tilastot")
                        .bold()
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100 , alignment: .center)
                    Text("Hae NBA-tilastoja halutun kauden, joukkueen ja suodatuksen mukaan")
                        .padding()
                    VStack {
                        HStack {
                            Text("Kausi")
                            Spacer()
                            Picker("Kausi", selection: $selectedSeason) {
                                ForEach(seasons, id: \.self) {
                                    Text($0)
                                }
                            }.pickerStyle(.menu)
                        }
                        
                        HStack {
                            Text("Joukkue")
                            Spacer()
                            Picker("Joukkue", selection: $selectedTeam) {
                                ForEach(teams, id: \.self) { team in
                                    Text(team.name)
                                }
                            }.pickerStyle(.menu)
                        }
                        
                        HStack {
                            Text("Suodatin")
                            Spacer()
                            Picker("Suodatin", selection: $selectedFilter) {
                                ForEach(filterOptions, id: \.self) {
                                    Text($0)
                                }
                            }.pickerStyle(.menu)
                        }
                    }.padding()
                    Spacer()
                    NavigationLink(destination: StatisticsView(statistics: statistics, isLoading: isLoading)) {
                        Text("Hae tilastot")
                            .font(.body)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .frame(width: 200.0, height: 50.0)
                            .background(Color.gray)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        clearOldStatistics()
                        fetchSeasonStatistics()
                    })
                    .cornerRadius(30)
                    .disabled(
                        selectedSeason.isEmpty ||
                        selectedTeam.name.isEmpty ||
                        selectedFilter.isEmpty
                    )
                    Spacer()
                }
            }
        }
    }
    
    func fetchSeasonStatistics() {
        Task {
            await WebApiRequest.fetchStatistics(season: selectedSeason, team: selectedTeam.abbreviation)
            // mäppää API-vastaus esitettävään StatisticsModel-muotoon
            let mappedStatistics = mapStatisticsViewModel()
            // filtteröi data käyttäjän valinnan mukaisesti
            let filteredStatistics = filterSeasonStatistics(statistics: mappedStatistics,filterOption: selectedFilter)
            if(filteredStatistics != nil) {
                // aseta filtteröidyt tilastot tilamuuttujaan
                setFilteredstatisticsToStateValiable(filteredStatistics: filteredStatistics!)
                isLoading = false
                print("stats: \(String(describing: filteredStatistics))")
            }
            else {
                isLoading = false
                print("Tilastoja ei löynyt!")
            }
        }  
    }
    
    func setFilteredstatisticsToStateValiable(filteredStatistics: StatisticsModel) {
        statistics.playerName = filteredStatistics.playerName
        statistics.position = filteredStatistics.position
        statistics.age = filteredStatistics.age
        statistics.games = filteredStatistics.games
        statistics.offensiveRb = filteredStatistics.offensiveRb
        statistics.defensiveRb = filteredStatistics.defensiveRb
        statistics.assists = filteredStatistics.assists
        statistics.steals = filteredStatistics.steals
        statistics.blocks = filteredStatistics.blocks
        statistics.turnovers = filteredStatistics.turnovers
        statistics.personalFouls = filteredStatistics.personalFouls
        statistics.points = filteredStatistics.points
        statistics.team = filteredStatistics.team
        statistics.season = filteredStatistics.season
    }
    
    func mapStatisticsViewModel() -> [StatisticsModel] {
        var mappedStatistics: [StatisticsModel] = []
        for stat in WebApiRequest.response {
            var mappedStat = StatisticsViewModel.mapStatisticsFromDto(statisticsDto: stat)
            mappedStat.team = selectedTeam.name
            mappedStat.position = getPlayerPositionFromAbbreviation(abbreviation: mappedStat.position)
            mappedStatistics.append(mappedStat)
        }
        return mappedStatistics
    }
    
    func getPlayerPositionFromAbbreviation(abbreviation: String) -> String {
        switch abbreviation {
        case "PG":
            return "Pelintekijä"
        case "SG":
            return "Heittävä takamies"
        case "SF":
            return "Pieni laitahyökkääjä"
        case "PF":
            return "Iso laitahyökkääjä"
        case "C":
            return "Sentteri"
        default:
            return ""
        }
    }
    
    func filterSeasonStatistics(statistics: [StatisticsModel], filterOption: String) -> StatisticsModel? {
        print("filter option: \(selectedFilter)")
        switch filterOption {
        case "Vähiten pisteitä":
            return statistics.max(by:{
                $0.points > $1.points
            })
        case "Eniten pisteitä":
            return statistics.max(by: {
                $0.points < $1.points
            })
        default:
            return nil
        }
    }
    
    func clearOldStatistics() {
    statistics = StatisticsModel(
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
