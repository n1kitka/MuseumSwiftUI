//
//  ObjectDetailVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.04.2024.
//

import Foundation
import Combine
import SwiftTfIdf

class ObjectDetailViewModel: ObservableObject {
    @Published var objectDetail: DetailObject?
    @Published var name = ""
    @Published var description = ""
    @Published var materials = ""
    @Published var eventTypeName = ""
    @Published var timeName = ""
    @Published var topWords = [String]()
    @Published var similarityScore: Double?
    
    let stopWordsManager = StopWordsManager()
    private var userProfileVM: UserProfileVM
    
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol
    private let objectId: Int
    
    init(objectId: Int, institutionService: InstitutionServiceProtocol = InstitutionService(), userProfileVM: UserProfileVM) {
        self.objectId = objectId
        self.institutionService = institutionService
        self.userProfileVM = userProfileVM
//        fetchObjectDetail()
    }

    func fetchObjectDetail() {
        institutionService.fetchObjectDetail(objectId: objectId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching object detail: \(error)")
                    self.objectDetail = nil
                }
            }, receiveValue: { [weak self] detailObject in
                self?.objectDetail = detailObject
                self?.prepareDisplayData(from: detailObject)
                self?.processDescriptionWithTfIdf(detailObject.object_description)
            })
            .store(in: &cancellables)
    }
    
    private func prepareDisplayData(from object: DetailObject) {
        self.name = object.object_name.isEmpty ? "Без імені" : "\(object.object_name)"
        self.description = object.object_description.isEmpty ? "Опис відсудній" : "\(object.object_description)"
        self.materials = object.object_material_technique.isEmpty ? "Матеріали невідомі" : "\(object.object_material_technique)"
    }
    
    private func processDescriptionWithTfIdf(_ text: String) {
        let textLength = text.count
//        let userTopN = userProfileVM.userProfile.interests.count
        
        var objectTopN: Int = 5
        if textLength < 100 {
            objectTopN = 3
        } else if textLength < 1000 {
            objectTopN = 5
        } else {
            objectTopN = 10
        }
        
        let objectTfIdf = SwiftTfIdf(text: text, stopWords: Array(stopWordsManager.stopWords), topN: objectTopN)
        
        let objectKeywords = objectTfIdf.finalCount().reduce(into: [String: Double]()) { (dict, item) in
            dict[item.key] = Double(item.value)
        }
        
        // Use binary frequency for user interests
        let userKeywords = Set(userProfileVM.userProfile.interests).reduce(into: [String: Double]()) { (dict, interest) in
            dict[interest] = 1.0
        }
        
        print("Object Keywords: \(objectKeywords)")
        print("User Keywords: \(userKeywords)")
        
        calculateCosineSimilarity(objectKeywords: objectKeywords, userKeywords: userKeywords)
    }
    
    private func calculateCosineSimilarity(objectKeywords: [String: Double], userKeywords: [String: Double]) {
        let allTerms = Set(objectKeywords.keys).union(userKeywords.keys)
        let objectVector = allTerms.map { objectKeywords[$0] ?? 0 }
        let userVector = allTerms.map { userKeywords[$0] ?? 0 }
        
        let dotProduct = zip(objectVector, userVector).reduce(0, { $0 + $1.0 * $1.1 })
        let magObject = sqrt(objectVector.map { $0 * $0 }.reduce(0, +))
        let magUser = sqrt(userVector.map { $0 * $0 }.reduce(0, +))
        let similarity = (magObject > 0 && magUser > 0) ? dotProduct / (magObject * magUser) : 0
        
        DispatchQueue.main.async {
            self.similarityScore = similarity
        }
        print("Cosine Similarity: \(similarity)")
        print("Object Vector: \(objectVector)")
        print("User Vector: \(userVector)")
    }
}




