//
//  InstitutionMapVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 07.03.2024.
//

import SwiftUI
import MapKit
import Combine

class InstitutionMapViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion

    init(coordinate: CLLocationCoordinate2D) {
        self.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }

    func zoomIn() {
        let newSpan = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta * 0.6, longitudeDelta: region.span.longitudeDelta * 0.6)
        withAnimation(.easeInOut(duration: 0.3)) {
            self.region = MKCoordinateRegion(center: self.region.center, span: newSpan)
        }
    }

    func zoomOut() {
        let newSpan = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta / 0.6, longitudeDelta: region.span.longitudeDelta / 0.6)
        withAnimation(.easeInOut(duration: 0.3)) {
            self.region = MKCoordinateRegion(center: self.region.center, span: newSpan)
        }
    }
}
