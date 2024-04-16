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
    @State private var userResponses: [Double] = Array(repeating: 0.5, count: 8)
    @State private var navigateToDetail = false
    @State private var selectedMuseumId: Int?

    let questions: [String] = [
        "Чи цікавитесь ви історією науки та астрономії?",
        "Чи захоплюєтеся ви технологіями та інженерією?",
        "Чи цікавитесь ви традиційним українським одягом та етнографією?",
        "Чи зацікавлені ви в широкому спектрі історії, від найдавніших часів до сучасності?",
        "Чи цікавитесь ви військовою історією та фортифікацією?",
        "Чи цікавлять вас наукові дослідження в галузі астрономії та її історії?",
        "Чи вас приваблюють історії успіху в галузі технічних наук і винаходів?",
        "Чи зацікавлені ви в діяльності музеїв, яка спрямована на збереження та популяризацію культурної спадщини?"
    ]
    
    let museumDatabase: [String: (id: Int, vector: [Double])] = [
        "Астрономічний музей Київського національного університету імені Тараса Шевченка": (id: 11, vector: [1, 0, 0, 0, 0, 1, 0, 0]),
        "Державний політехнічний музей імені Бориса Патона": (id: 13, vector: [0, 1, 0, 0, 0, 0, 1, 0]),
        "Колекція \"Відкрита скриня\"": (id: 15, vector: [0, 0, 1, 0, 0, 0, 0, 0]),
        "Національний музей історії України": (id: 18, vector: [0, 0, 0, 1, 0, 0, 0, 1]),
        "Національний історико-архітектурний музей “Київська фортеця”": (id: 19, vector: [0, 0, 0, 0, 1, 0, 0, 0])
    ]

    
    var body: some View {
        NavigationView {
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
                    NavigationLink(destination: InstitutionDetailView(viewModel: InstitutionDetailViewModel(institutionId: museumId)), isActive: $navigateToDetail) {
                        EmptyView()
                    }.hidden()
                }
            }
            .navigationBarTitle("Опитування", displayMode: .inline)
        }
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




