//
//  DetailInstitution.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 05.03.2024.
//

import Foundation

struct DetailInstitution: Codable, Identifiable {
    let id: Int
    let name: String
    let telephone: String
    let fax: String
    let mail: String
    let description: String
    let latitude: Double
    let longitude: Double
    var image: String
    let numberOfObjects: Int
    let street: String
    let openingHours: OpeningHours?
    let accessibility: Bool
    let isPhoto: Bool
    let isCloakroom: Bool
    let isLockers: Bool
    let isShop: Bool
    let isCafe: Bool
    let isBabycare: Bool
    var collectionsDictionary: [String: Collection]
    var collections: [Collection] {
        return Array(collectionsDictionary.values)
    }

    enum CodingKeys: String, CodingKey {
        case id = "institution_id"
        case name = "institution_name"
        case telephone = "institution_telnr"
        case fax = "institution_fax"
        case mail = "institution_mail"
        case description = "institution_description"
        case latitude = "institution_latitude"
        case longitude = "institution_longitude"
        case numberOfObjects = "institution_number_of_objects"
        case image = "institution_image"
        case street = "institution_street"
        case openingHours = "opening_hours"
        case accessibility
        case isPhoto = "photos_allowed"
        case isCloakroom = "cloakroom_available"
        case isLockers = "lockers_available"
        case isShop = "shop_available"
        case isCafe = "cafe_available"
        case isBabycare = "babycare_room_available"
        case collectionsDictionary = "collections"
    }
}

struct OpeningHours: Codable {
    let note: String
    let days: [[DaySchedule]]
}

struct DaySchedule: Codable {
    let start: String
    let end: String
    let note: String?
}

