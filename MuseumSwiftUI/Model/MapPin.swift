//
//  MapPin.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 09.03.2024.
//

import Foundation
import MapKit

struct MapPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
