//
//  CollectionDetailVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 02.04.2024.
//

import Foundation
import Combine
import SwiftTfIdf

class CollectionDetailViewModel: ObservableObject {
    @Published var collection: Collection?
    @Published var name = ""
    @Published var description = ""
    @Published var image: String = ""
    @Published var numberOfObjects: Int = 0
    @Published var subcollections: [Subcollection] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol
    public let collectionId: Int
    
    var subcollectionsText: String {
        subcollections.isEmpty ? "Це зібрання не містить розділів" : "Це зібрання містить такі розділи"
    }
    
    init(collectionId: Int, institutionService: InstitutionServiceProtocol = InstitutionService()) {
        self.collectionId = collectionId
        self.institutionService = institutionService
        fetchCollectionDetail()
    }

    private func fetchCollectionDetail() {
        institutionService.fetchCollectionDetail(collectionId: collectionId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching collection detail: \(error)")
                    self?.collection = nil
                }
            }, receiveValue: { [weak self] collection in
                var collection = collection
                collection.isFavorite = UserDefaults.standard.bool(forKey: "favorite_\(collection.id)")
                self?.collection = collection
                self?.prepareDisplayData(from: collection)
            })
            .store(in: &cancellables)
    }
    
    func toggleFavorite() {
        guard let collection = collection else { return }
        let newFavoriteState = !collection.isFavorite
        UserDefaults.standard.set(newFavoriteState, forKey: "favorite_\(collectionId)")
        self.collection?.isFavorite = newFavoriteState
    }

    private func prepareDisplayData(from collection: Collection) {
        self.name = collection.name
        self.description = collection.description
        self.image = collection.image.contains("http://") || collection.image.contains("https://") ? collection.image : "https://assets.museum-digital.org/ua-kyiv/" + collection.image
        self.numberOfObjects = collection.numberOfObjects
        self.subcollections = collection.subcollections?.map { subcollection -> Subcollection in
            var correctedSubcollection = subcollection
            correctedSubcollection.image = formatImageUrl(subcollection.image)
            return correctedSubcollection
        } ?? []
    }

    private func formatImageUrl(_ imageUrl: String) -> String {
        if imageUrl.contains("http://") || imageUrl.contains("https://") {
            return imageUrl
        } else {
            return "https://assets.museum-digital.org/ua-kyiv/" + imageUrl
        }
    }
    
    
}

