//
//  CollectionView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 08.03.2024.
//

import SwiftUI
import CachedAsyncImage

struct CollectionsView: View {
    @ObservedObject var viewModel: InstitutionDetailViewModel
    
    var body: some View {
        List(viewModel.collections, id: \.id) { collection in
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
                        Text("\(collection.numberOfObjects) об'єкти")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Зібрання")
    }
}






