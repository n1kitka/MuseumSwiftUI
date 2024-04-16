//
//  Subcollection.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 12.03.2024.
//

import Foundation

struct Subcollection: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    var image: String
    let description: String
    let numberOfObjects: Int

    enum CodingKeys: String, CodingKey {
        case id = "collection_id"
        case name = "collection_name"
        case image = "collection_image"
        case description = "collection_description"
        case numberOfObjects = "collection_number_of_objects"
    }
}
