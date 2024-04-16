//
//  InstitutionService.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.03.2024.
//

import Foundation
import Combine

protocol InstitutionServiceProtocol {
    func fetchInstitutions() -> AnyPublisher<[Institution], Error>
    func fetchInstitutionDetail(institutionId: Int) -> AnyPublisher<DetailInstitution, Error>
    func fetchCollectionDetail(collectionId: Int) -> AnyPublisher<Collection, Error>
    func fetchObjectsByCollectionId(_ collectionId: Int, page: Int) -> AnyPublisher<[MuseumObject], Error>
    func fetchObjectDetail(objectId: Int) -> AnyPublisher<DetailObject, Error>
    func fetchAllCollections() -> AnyPublisher<[DetailInstitution], Error>
    func fetchAllObjects(page: Int) -> AnyPublisher<[MuseumObject], Error>
}

class InstitutionService: InstitutionServiceProtocol {
    func fetchInstitutions() -> AnyPublisher<[Institution], Error> {
        let urlString = "https://kyiv.ua.museum-digital.org/json/institutions"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Institution].self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func fetchAllCollections() -> AnyPublisher<[DetailInstitution], Error> {
        fetchInstitutions()
            .flatMap { institutions in
                Publishers.MergeMany(institutions.map { self.fetchInstitutionDetail(institutionId: $0.id) })
                    .collect()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchAllObjects(page: Int = 1) -> AnyPublisher<[MuseumObject], Error> {
        let itemsPerPage = 24
        let startwert = (page - 1) * itemsPerPage
        let urlString = "https://kyiv.ua.museum-digital.org/json/objects?section=results_list&mode=grid&startwert=\(startwert)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [MuseumObject].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }


    
    func fetchInstitutionDetail(institutionId: Int) -> AnyPublisher<DetailInstitution, Error> {
        let urlString = "https://kyiv.ua.museum-digital.org/json/institution/\(institutionId)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: DetailInstitution.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func fetchCollectionDetail(collectionId: Int) -> AnyPublisher<Collection, Error> {
        let urlString = "https://kyiv.ua.museum-digital.org/json/collection/\(collectionId)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Collection.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func fetchObjectsByCollectionId(_ collectionId: Int, page: Int = 1) -> AnyPublisher<[MuseumObject], Error> {
        // Assuming each page has 24 items. Adjust if the API uses a different number.
        let itemsPerPage = 24
        let startwert = (page - 1) * itemsPerPage
        
        let urlString = "https://kyiv.ua.museum-digital.org/json/objects?s=collection:\(collectionId)&startwert=\(startwert)"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [MuseumObject].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    
    func fetchObjectDetail(objectId: Int) -> AnyPublisher<DetailObject, Error> {
        guard let url = URL(string: "https://kyiv.ua.museum-digital.org/json/object/\(objectId)") else {
            fatalError("Invalid URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: DetailObject.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}
