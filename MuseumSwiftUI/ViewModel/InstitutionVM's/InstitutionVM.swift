//
//  InstitutionVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.03.2024.
//

import Foundation
import Combine

class InstitutionViewModel: ObservableObject {
    @Published var institutions: [Institution] = []
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol

    init(institutionService: InstitutionServiceProtocol = InstitutionService()) {
        self.institutionService = institutionService
    }

    func fetchInstitutions() {
        institutionService.fetchInstitutions()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching data: \(error)")
                    self?.institutions = [] // Handle error state as needed
                }
            }, receiveValue: { [weak self] institutions in
                let baseURL = "https://kyiv.ua.museum-digital.org/"
                self?.institutions = institutions.map { institution -> Institution in
                    var modifiedInstitution = institution
                    if !institution.image.contains("http://") && !institution.image.contains("https://") {
                        modifiedInstitution.image = baseURL + institution.image
                    }
                    return modifiedInstitution
                }
            })
            .store(in: &cancellables)
    }
}



