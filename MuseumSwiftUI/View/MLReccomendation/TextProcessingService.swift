//
//  TextProcessingService.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 03.05.2024.
//

import Foundation
import SwiftTfIdf

struct TextProcessingService {

    static let shared = TextProcessingService()
    private let stopWordsManager = StopWordsManager()

    func calculateTopKeywords(from text: String, topN: Int) -> [String: Double] {
        let objectTfIdf = SwiftTfIdf(text: text, stopWords: Array(stopWordsManager.stopWords), topN: topN)
        return objectTfIdf.finalCount().reduce(into: [String: Double]()) { (dict, item) in
            dict[item.key] = Double(item.value)
        }
    }

    func calculateCosineSimilarity(between vector1: [String: Double], and vector2: [String: Double]) -> Double {
        let allTerms = Set(vector1.keys).union(vector2.keys)
        let vector1Values = allTerms.map { vector1[$0] ?? 0 }
        let vector2Values = allTerms.map { vector2[$0] ?? 0 }
        
        let dotProduct = zip(vector1Values, vector2Values).reduce(0, { $0 + $1.0 * $1.1 })
        let magVector1 = sqrt(vector1Values.map { $0 * $0 }.reduce(0, +))
        let magVector2 = sqrt(vector2Values.map { $0 * $0 }.reduce(0, +))
        return (magVector1 > 0 && magVector2 > 0) ? dotProduct / (magVector1 * magVector2) : 0
    }

    func selectTopNKeywords(keywords: [String: Double], count: Int) -> [String] {
        return keywords.sorted(by: { $0.value > $1.value }).map { "\($0.key) (\($0.value))" }.prefix(count).map { $0 }
    }
}


