//
//  InstitutionMapView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 08.03.2024.
//

import SwiftUI
import MapKit

struct InstitutionMapView: View {
    @ObservedObject var viewModel: InstitutionMapViewModel

    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: false, userTrackingMode: nil, annotationItems: [MapPin(coordinate: viewModel.region.center)]) { pin in
                MapMarker(coordinate: pin.coordinate, tint: .red)
            }

            // Zoom controls
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.zoomIn()
                }) {
                    Image(systemName: "plus")
                }

                Button(action: {
                    viewModel.zoomOut()
                }) {
                    Image(systemName: "minus")
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(Capsule())
            .shadow(radius: 3)
            .font(.title)
        }
    }
}


