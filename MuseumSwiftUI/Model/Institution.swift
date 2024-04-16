//
//  Institution.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.03.2024.
//

import Foundation

struct Institution: Codable, Identifiable {
    let id: Int
    let name: String
    let place: String
    let url: String
    var image: String
    let collections: Int
    let objects: Int

    
    enum CodingKeys: String, CodingKey {
        case id = "institution_id"
        case name = "institution_name"
        case place = "institution_place"
        case url = "institution_url"
        case image = "institution_image"
        case collections = "institution_collections"
        case objects = "institution_objects"
    }
}


