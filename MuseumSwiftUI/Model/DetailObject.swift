//
//  DetailObject.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.04.2024.
//

import Foundation

struct DetailObject: Codable, Identifiable {
    let object_id: Int
    let object_name: String
    let object_description: String
    let object_material_technique: String
    let object_images: [ObjectImage]
//    let object_events: [ObjectEvent]
    var topKeywords: [String]?
    
    var id: Int { object_id }

    struct ObjectImage: Codable {
        let folder: String
        let filename_loc: String
        let name: String
        let is_main: String
        let preview: String
        var fullImageUrl: URL? {
            URL(string: "https://asset.museum-digital.org/ua-kyiv/\(folder)/500w_\(filename_loc)")
        }
    }
    
//    struct ObjectEvent: Codable {
//        let event_type_name: String
//        let time: EventTime
//    }
//    
//    // Define the structure for the event time
//    struct EventTime: Codable {
//        let time_name: String
//    }
}

