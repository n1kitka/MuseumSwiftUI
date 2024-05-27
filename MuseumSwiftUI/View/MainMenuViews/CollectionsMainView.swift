//
//  CollectionsMainView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 15.04.2024.
//

import SwiftUI
import CachedAsyncImage

struct CollectionsSelectionView: View {
    var body: some View {
        VStack(spacing: 20) {
            List() {
                NavigationLink("Всі", destination: CollectionsMainView())
                NavigationLink("Обрані", destination: FavoritesCollectionsView())
            }
        }
        .navigationBarTitle("Зібрання", displayMode: .inline)
    }
}

struct CollectionsMainView: View {
    @ObservedObject var viewModel = AllInstitutionsViewModel(userProfileVM: UserProfileVM.shared)
    
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
                                        EmptyView()
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

struct FavoritesCollectionsView: View {
    @ObservedObject var viewModel = AllInstitutionsViewModel(userProfileVM: UserProfileVM.shared)

    var body: some View {
        List(viewModel.allCollections.flatMap { $0.collections }.filter { UserDefaults.standard.bool(forKey: "favorite_\($0.id)") }, id: \.id) { collection in
            NavigationLink(destination: CollectionDetailView(viewModel: CollectionDetailViewModel(collectionId: collection.id))) {
                VStack(alignment: .leading) {
                    Text(collection.name)
                        .font(.headline)
                    CachedAsyncImage(url: URL(string: collection.image), urlCache: .imageCache) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else if phase.error != nil {
                            EmptyView()
                        } else {
                            ProgressView()
                        }
                    }
                    .padding(.trailing, 5)
                }
            }
        }
        .navigationTitle("Обрані зібрання")
    }
}


