//
//  ObjectDetailVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.04.2024.
//

import Foundation
import Combine
import NaturalLanguage
import SwiftTfIdf

class ObjectDetailViewModel: ObservableObject {
    @Published var objectDetail: DetailObject?
    @Published var recommendedObjects: [DetailObject] = []
    
    @Published var name = ""
    @Published var description = ""
    @Published var materials = ""
    @Published var eventTypeName = ""
    @Published var timeName = ""
    @Published var topWords = [String]()
    
    let stopWordsManager = StopWordsManager()
    let visitorInterests = ["історія", "мистецтво", "монета", "чаша", "картина"]
    
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol
    private let objectId: Int
    
    init(objectId: Int, institutionService: InstitutionServiceProtocol = InstitutionService()) {
        self.objectId = objectId
        self.institutionService = institutionService
    }
    
    func fetchDetailsAndRecommend() {
        fetchObjectDetail()
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
        let swiftTfIdf = SwiftTfIdf(text: text, stopWords: Array(stopWordsManager.stopWords), topN: 5)
        let topTerms = swiftTfIdf.finalCount().map { $0.key }
        let results = swiftTfIdf.finalCount()
        print("Top TF-IDF terms: \(String(describing: results))")
        DispatchQueue.main.async {
            self.objectDetail?.topKeywords = topTerms
            self.topWords = topTerms
        }
    }

}

