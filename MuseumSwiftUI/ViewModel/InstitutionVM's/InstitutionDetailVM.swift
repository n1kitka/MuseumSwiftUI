//
//  InstitutionDetailVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 05.03.2024.
//

import Foundation
import Combine

class InstitutionDetailViewModel: ObservableObject {
    @Published var detail: DetailInstitution?
    @Published var address = ""
    @Published var phoneNumber = ""
    @Published var name = ""
    @Published var description = ""
    @Published var openingHoursDescription: String = ""
    @Published var collections: [Collection] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol
    private let institutionId: Int
    private let weekDays = ["Понеділок", "Вівторок", "Середа", "Четвер", "П'ятниця", "Субота", "Неділя"]

    init(institutionId: Int, institutionService: InstitutionServiceProtocol = InstitutionService()) {
        self.institutionId = institutionId
        self.institutionService = institutionService
        fetchInstitutionDetail()
    }

    private func fetchInstitutionDetail() {
        institutionService.fetchInstitutionDetail(institutionId: institutionId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching institution detail: \(error)")
                    self?.detail = nil
                }
            }, receiveValue: { [weak self] detail in
                var modifiedDetail = detail
                let baseURL = "https://assets.museum-digital.org/ua-kyiv/"
                let alternateBaseURL = "https://kyiv.ua.museum-digital.org/"
                if !detail.image.contains("http://") && !detail.image.contains("https://") {
                    modifiedDetail.image = baseURL + detail.image
                }
                
                modifiedDetail.collectionsDictionary = modifiedDetail.collectionsDictionary.mapValues { collection in
                    var modifiedCollection = collection
                    if !collection.image.contains("http://") && !collection.image.contains("https://") {
                        modifiedCollection.image = collection.image.hasPrefix("data/ua-kyiv/") ? alternateBaseURL + collection.image : baseURL + collection.image
                    }
                    return modifiedCollection
                }
                
                self?.detail = modifiedDetail
                self?.prepareDisplayData(from: detail)
                self?.collections = Array(modifiedDetail.collectionsDictionary.values).sorted {$0.name < $1.name}
            })
            .store(in: &cancellables)
    }

    private func prepareDisplayData(from detail: DetailInstitution) {
        self.address = detail.street.isEmpty ? "Адреса не вказана" : "📍 Адреса: \(detail.street)"
        self.phoneNumber = detail.telephone.isEmpty ? "Номер телефону не вказаний" : "📞 Номер телефону: \(detail.telephone)"
        self.name = detail.name.isEmpty ? "Назва не вказана" : "\(detail.name)"
        self.description = detail.description.isEmpty ? "Опис недоступний" : "\(detail.description)"
        
        if let openingHours = detail.openingHours, !openingHours.days.isEmpty {
            self.openingHoursDescription = openingHours.days.enumerated().reduce(into: openingHours.note) { result, indexDay in
                let (index, day) = indexDay
                if let schedule = day.first {
                    result += "\n\(weekDays[index]): \(schedule.start) - \(schedule.end) \(schedule.note ?? "")"
                }
            }
        } else {
            self.openingHoursDescription = "Будь ласка, уточніть актуальні години роботи у працівників музею"
        }
    }
}




