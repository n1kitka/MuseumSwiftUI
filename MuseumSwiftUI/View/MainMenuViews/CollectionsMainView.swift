//
//  CollectionsMainView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 15.04.2024.
//

import SwiftUI
import CachedAsyncImage

struct CollectionsMainView: View {
    @ObservedObject var viewModel = AllInstitutionsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.allCollections, id: \.id) { institution in
                Section(header: Text(institution.name)) {
                    ForEach(institution.collections, id: \.id) { collection in
                        NavigationLink(destination: CollectionDetailView(viewModel: CollectionDetailViewModel(collectionId: collection.id))) {
                            HStack {
                                CachedAsyncImage(url: URL(string: collection.image), urlCache: .imageCache) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } else if phase.error != nil {
                                        Image(systemName: "photo")
                                            .frame(width: 50, height: 50)
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .padding(.trailing, 5)
                                
                                VStack(alignment: .leading) {
                                    Text(collection.name)
                                        .font(.headline)
                                    Text("\(collection.numberOfObjects) об'єктів")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Зібрання")
        
    }
}

