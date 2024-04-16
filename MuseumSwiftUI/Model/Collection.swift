//
//  Collection.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 05.03.2024.
//

import Foundation

struct Collection: Codable, Identifiable {
    let id: Int
    let name: String
    var image: String
    let description: String
    let numberOfObjects: Int
    let subcollections: [Subcollection]?
    
    enum CodingKeys: String, CodingKey {
        case id = "collection_id"
        case name = "collection_name"
        case image = "collection_image"
        case description = "collection_description"
        case numberOfObjects = "collection_number_of_objects"
        case subcollections = "collection_subcollections"
    }
}
