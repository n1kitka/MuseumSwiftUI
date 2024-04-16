//
//  InstitutionView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.03.2024.
//

import SwiftUI
import CachedAsyncImage

struct InstitutionsView: View {
    @ObservedObject var viewModel = InstitutionViewModel()

    var body: some View {
//        NavigationView {
            List(viewModel.institutions, id: \.id) { institution in
                NavigationLink(destination: InstitutionDetailView(viewModel: InstitutionDetailViewModel(institutionId: institution.id))) {
                    HStack {
                        CachedAsyncImage(url: URL(string: institution.image), urlCache: .imageCache) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else if phase.error != nil {
                                Image(systemName: "photo")
                                    .imageScale(.large)
                            } else {
                                ProgressView()
                            }
                        }
                        .padding(.trailing, 5)
                        
                        VStack(alignment: .leading) {
                            Text(institution.name)
                                .font(.headline)
                            Text(institution.place)
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(institution.collections) Зібрання")
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text("\(institution.objects) Об'єкти")
                                .font(.subheadline)
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                    }
                }
            }
            .navigationTitle("Музеї")
//        }
        .onAppear {
            viewModel.fetchInstitutions()
        }
    }
}


