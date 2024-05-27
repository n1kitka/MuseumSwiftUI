//
//  AllObjectsVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 16.04.2024.
//

import Foundation
import Combine

class AllObjectsViewModel: ObservableObject {
    @Published var objects: [MuseumObject] = []
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol
    private var currentPage = 1
    var canLoadMore = true

    init(institutionService: InstitutionServiceProtocol = InstitutionService()) {
        self.institutionService = institutionService
        fetchAllObjects()
    }

    func fetchAllObjects() {
        guard canLoadMore else { return }

        institutionService.fetchAllObjects(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching all objects: \(error)")
                    self?.canLoadMore = false
                }
            }, receiveValue: { [weak self] objects in
                if objects.isEmpty {
                    self?.canLoadMore = false // Stop further loading if no objects are returned
                } else {
                    self?.objects.append(contentsOf: objects)
                    self?.currentPage += 1 // Prepare for fetching the next page
                }
            })
            .store(in: &cancellables)
    }
    
    func loadMoreObjects() {
        if canLoadMore {
            fetchAllObjects()
        }
    }
}
