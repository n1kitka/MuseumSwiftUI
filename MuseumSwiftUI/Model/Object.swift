//
//  Object.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 03.04.2024.
//

import Foundation

struct MuseumObject: Identifiable, Decodable {
    var id: Int { objekt_id }
    let objekt_id: Int
    let objekt_name: String
    let objekt_inventarnr: String
    let objekt_erfasst_am: String
    let institution_id: Int
    let institution_name: String
    let image: String
    let image_height: Int
    let total: Int
}
