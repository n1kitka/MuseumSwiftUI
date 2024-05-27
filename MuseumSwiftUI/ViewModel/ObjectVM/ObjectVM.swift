//
//  ObjectVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 03.04.2024.
//

import Foundation
import Combine

class ObjectViewModel: ObservableObject {
    @Published var objects: [MuseumObject] = []
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol
    private let collectionId: Int
    
    private var currentPage = 1
    var canLoadMore = true

    init(collectionId: Int, institutionService: InstitutionServiceProtocol = InstitutionService()) {
        self.collectionId = collectionId
        self.institutionService = institutionService
        fetchObjects()
    }

    func fetchObjects() {
        guard canLoadMore else { return }
    
        institutionService.fetchObjectsByCollectionId(collectionId, page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching objects: \(error)")
                }
            }, receiveValue: { [weak self] objects in
                if objects.isEmpty {
                    self?.canLoadMore = false
                } else {
                    self?.objects.append(contentsOf: objects)
                    self?.currentPage += 1
                }
            })
            .store(in: &cancellables)
    }
}




