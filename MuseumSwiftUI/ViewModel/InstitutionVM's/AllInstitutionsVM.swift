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
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol

    init(institutionService: InstitutionServiceProtocol = InstitutionService()) {
        self.institutionService = institutionService
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
            return modifiedCollection
        }

        return modifiedDetail
    }
}



