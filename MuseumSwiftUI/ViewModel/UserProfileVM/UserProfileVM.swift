//
//  UserProfileVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 18.04.2024.
//

import Combine
import SwiftUI
import SwiftTfIdf

class UserProfileVM: ObservableObject {
    static let shared = UserProfileVM()
    
    @Published var userProfile: UserProfile {
        didSet {
            saveInterests()
        }
    }
    
    @Published var inputInterest: String = ""
    @Published var recommendedInstitution: DetailInstitution?
    
    private var cancellables = Set<AnyCancellable>()
    private let institutionService: InstitutionServiceProtocol = InstitutionService()

    private init() {
        self.userProfile = UserProfile(interests: [])
        loadInterests()
    }

    func addInterest() {
        let cleanedInterest = inputInterest.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !cleanedInterest.isEmpty && !userProfile.interests.contains(cleanedInterest) {
            userProfile.interests.append(cleanedInterest)
            inputInterest = ""
        }
    }

    func removeInterest(at index: IndexSet) {
        userProfile.interests.remove(atOffsets: index)
    }

    private func saveInterests() {
        UserDefaults.standard.set(userProfile.interests, forKey: "userInterests")
    }

    private func loadInterests() {
        if let interests = UserDefaults.standard.array(forKey: "userInterests") as? [String] {
            userProfile.interests = interests
        }
    }
    
    func getRecommendation() {
        institutionService.fetchAllCollections()
            .map { institutions -> DetailInstitution? in
                let scores = institutions.map { institution -> (DetailInstitution, Double) in
                    let score = self.calculateSimilarityScore(for: institution)
                    return (institution, score)
                }
                return scores.max(by: { $0.1 < $1.1 })?.0
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching institutions: \(error)")
                }
            }, receiveValue: { [weak self] institution in
                self?.recommendedInstitution = institution
            })
            .store(in: &cancellables)
    }

    private func calculateSimilarityScore(for institution: DetailInstitution) -> Double {
        let institutionDescription = institution.description
        var objectTopN: Int = 5
        let textLength = institutionDescription.count
        if textLength < 100 {
            objectTopN = 3
        } else if textLength < 1000 {
            objectTopN = 5
        } else {
            objectTopN = 10
        }

        let institutionKeywords = TextProcessingService.shared.calculateTopKeywords(from: institutionDescription, topN: objectTopN)

        let userInterests = userProfile.interests
        let userKeywords = userInterests.reduce(into: [String: Double]()) { (dict, interest) in
            dict[interest, default: 0.0] += 1.0
        }

        return TextProcessingService.shared.calculateCosineSimilarity(between: institutionKeywords, and: userKeywords)
    }

}



