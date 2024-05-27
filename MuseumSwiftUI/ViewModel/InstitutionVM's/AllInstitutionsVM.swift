//
//  AllInstitutionsVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 15.04.2024.
//

import Foundation
import Combine

class AllInstitutionsViewModel: ObservableObject {
    @Published var allCollections: [DetailInstitution] = []
    @Published var similarityScore: Double?
    @Published var topKeywords: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol
    private var userProfileVM: UserProfileVM
    private let stopWordsManager = StopWordsManager()

    init(institutionService: InstitutionServiceProtocol = InstitutionService(), userProfileVM: UserProfileVM) {
        self.institutionService = institutionService
        self.userProfileVM = userProfileVM
        fetchAllCollections()
    }

    func fetchAllCollections() {
        institutionService.fetchAllCollections()
            .receive(on: DispatchQueue.main)
            .map { [weak self] details -> [DetailInstitution] in
                guard let self = self else { return [] }
                return details.map { self.modifyInstitutionDetail($0) }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error while fetching all collections: \(error)")
                }
            }, receiveValue: { [weak self] modifiedDetails in
                self?.allCollections = modifiedDetails.sorted {$0.name < $1.name}
            })
            .store(in: &cancellables)
    }

    private func modifyInstitutionDetail(_ detail: DetailInstitution) -> DetailInstitution {
        var modifiedDetail = detail
        let baseURL = "https://assets.museum-digital.org/ua-kyiv/"
        let alternateBaseURL = "https://kyiv.ua.museum-digital.org/"

        if !modifiedDetail.image.contains("http://") && !modifiedDetail.image.contains("https://") {
            modifiedDetail.image = baseURL + modifiedDetail.image
        }

        modifiedDetail.collectionsDictionary = modifiedDetail.collectionsDictionary.mapValues { collection in
            var modifiedCollection = collection
            if !collection.image.contains("http://") && !collection.image.contains("https://") {
                modifiedCollection.image = collection.image.hasPrefix("data/ua-kyiv/") ? alternateBaseURL + collection.image : baseURL + collection.image
            }
            self.processDescriptionWithTfIdf(collection.description)
            let isFavorite = self.similarityScore! > 0.2
            UserDefaults.standard.set(isFavorite, forKey: "favorite_\(collection.id)")
            return modifiedCollection
        }

        return modifiedDetail
    }
    
    private func processDescriptionWithTfIdf(_ text: String) {
        let textLength = text.count
        var objectTopN: Int = 5
        if textLength < 100 {
            objectTopN = 3
        } else if textLength < 500 {
            objectTopN = 5
        } else {
            objectTopN = 10
        }
        
        let termFrequencies = TextProcessingService.shared.calculateTopKeywords(from: text, topN: objectTopN)
        topKeywords = TextProcessingService.shared.selectTopNKeywords(keywords: termFrequencies, count: objectTopN)
        print("TOPKEYWORDS \(topKeywords)")
        let userKeywords = userProfileVM.userProfile.interests.reduce(into: [String: Double]()) { (dict, interest) in
            dict[interest] = 1.0
        }
        
        similarityScore = TextProcessingService.shared.calculateCosineSimilarity(between: termFrequencies, and: userKeywords)
        print("Cosine Similarity for collection: \(similarityScore ?? 0)")
    }
}



