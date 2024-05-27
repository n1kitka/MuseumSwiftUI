//
//  InstitutionDetailView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 05.03.2024.
//

import SwiftUI
import MapKit
import CachedAsyncImage

struct InstitutionDetailView: View {
    @ObservedObject var viewModel: InstitutionDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let detail = viewModel.detail {
                    CachedAsyncImage(url: URL(string: detail.image), urlCache: .imageCache) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .imageScale(.large)
                        } else {
                            ProgressView()
                        }
                    }
                    .padding()
                    
                    Group {
                        Text(viewModel.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(viewModel.address)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.phoneNumber)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    Text("🕔 Години роботи:")
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    Text(viewModel.openingHoursDescription)
                        .padding(.horizontal)
                    
                    Text("Опис")
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    Text(viewModel.description)
                        .padding(.horizontal)
                    
                    Text("Схожість: \((viewModel.similarityScore ?? 100) * 100, specifier: "%.2f")%")
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    Text("Зручності та послуги")
                        .font(.title3)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        FeatureView(featureName: "Доступ для людей з обмеженими можливостями", isAvailable: detail.accessibility)
                        FeatureView(featureName: "Фото та відеозйомка", isAvailable: detail.isPhoto)
                        FeatureView(featureName: "Гардероб", isAvailable: detail.isCloakroom)
                        FeatureView(featureName: "Шафи для зберігання", isAvailable: detail.isLockers)
                        FeatureView(featureName: "Музейний магазин", isAvailable: detail.isShop)
                        FeatureView(featureName: "Кафе", isAvailable: detail.isCafe)
                        FeatureView(featureName: "Кімната для догляду за дитиною", isAvailable: detail.isBabycare)
                    }
                    
                    // Navigation to CollectionsView
                    NavigationLink(destination: CollectionsView(viewModel: viewModel)) {
                        Text("Переглянути зібрання")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    InstitutionMapView(viewModel: InstitutionMapViewModel(coordinate: CLLocationCoordinate2D(latitude: detail.latitude, longitude: detail.longitude)))
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Text("Завантаження даних...")
                        .padding()
                }
            }
        }
        .navigationTitle("Про музей")
        .onAppear {
            viewModel.fetchInstitutionDetail()
        }
    }
}





