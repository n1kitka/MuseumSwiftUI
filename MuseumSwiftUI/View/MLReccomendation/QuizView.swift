//
//  QuizView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 19.03.2024.
//

import SwiftUI

struct MuseumRecommendation: Identifiable {
    let id: Int
    let name: String
}

struct QuizView: View {
    @State private var userResponses: [Double] = Array(repeating: 0.5, count: 15)
    @State private var navigateToDetail = false
    @State private var selectedMuseumId: Int?

    let questions: [String] = [
        "Чи цікавитеся ви астрономією та космічними дослідженнями?",
        "Чи зацікавлені ви в історії науки та освіти?",
        "Чи подобається вам відвідувати музеї з академічним нахилом?",
        "Чи цікавить вас історія технологій і інженерії?",
        "Чи зацікавлені ви в музеях, які демонструють розвиток промисловості та техніки?",
        "Чи хотіли б ви відвідати музей з великою кількістю експонатів з інженерії?",
        "Чи зацікавлені ви в українському традиційному одязі та народному мистецтві?",
        "Чи подобається вам вивчати культурну спадщину через предмети побуту та одяг?",
        "Чи віддаєте ви перевагу музеям, які зосереджені на збереженні традицій?",
        "Чи цікавитеся ви історією України з давніх часів до сьогодення?",
        "Чи хотіли б ви дізнатися більше про археологічні знахідки та історичні артефакти?",
        "Чи важливо для вас відвідувати музеї з широким спектром історичних колекцій?",
        "Чи зацікавлені ви в історії фортифікацій та оборонних споруд?",
        "Чи подобається вам дізнаватися про використання історичних споруд у різні історичні періоди?",
        "Чи віддаєте перевагу музеям, які мають науково-дослідну та освітню діяльність?"
    ]
    
    let museumDatabase: [String: (id: Int, vector: [Double])] = [
        "Астрономічний музей Київського національного університету імені Тараса Шевченка": (id: 11, vector: [1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
        "Державний політехнічний музей імені Бориса Патона": (id: 13, vector: [0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
        "Колекція \"Відкрита скриня\"": (id: 15, vector: [0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0]),
        "Національний музей історії України": (id: 18, vector: [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0]),
        "Національний історико-архітектурний музей “Київська фортеця”": (id: 19, vector: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1])
    ]
    
    var body: some View {
//        NavigationView {
            Form {
                ForEach(0..<questions.count, id: \.self) { index in
                    Section(header: Text(questions[index])) {
                        Picker("Ваша відповідь", selection: $userResponses[index]) {
                            Text("Так").tag(1.0)
                            Text("Не знаю").tag(0.5)
                            Text("Ні").tag(0.0)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Button("Отримати рекомендацію") {
                    if let recommendation = recommendMuseum(for: userResponses, using: museumDatabase) {
                        selectedMuseumId = recommendation.id
                        navigateToDetail = true
                    }
                }
                if let museumId = selectedMuseumId {
                    NavigationLink(destination: InstitutionDetailView(viewModel: InstitutionDetailViewModel(institutionId: museumId, userProfileVM: UserProfileVM.shared)), isActive: $navigateToDetail) {
                        EmptyView()
                    }.hidden()
                }
            }
            .navigationBarTitle("Опитування", displayMode: .inline)
//        }
    }
    
    func recommendMuseum(for userResponses: [Double], using museumDatabase: [String: (id: Int, vector: [Double])]) -> MuseumRecommendation? {
        var bestMatch: (name: String, id: Int)? = nil
        var lowestMSE: Double = Double.greatestFiniteMagnitude

        for (museum, data) in museumDatabase {
            let mse = meanSquaredError(between: userResponses, and: data.vector)
            if mse < lowestMSE {
                lowestMSE = mse
                bestMatch = (name: museum, id: data.id)
            }
        }
        
        guard let match = bestMatch else { return nil }
        return MuseumRecommendation(id: match.id, name: match.name)
    }

    
    func meanSquaredError(between userResponses: [Double], and museumVector: [Double]) -> Double {
        let squaredDifferences = zip(userResponses, museumVector).map { (userScore, museumScore) in
            (userScore - museumScore) * (userScore - museumScore)
        }
        let meanSquaredError = squaredDifferences.reduce(0, +) / Double(squaredDifferences.count)
        return meanSquaredError
    }
}




