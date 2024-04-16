//
//  ObjectsMainView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 16.04.2024.
//

import SwiftUI
import CachedAsyncImage

struct ObjectsMainView: View {
    @ObservedObject var viewModel: AllObjectsViewModel

    var body: some View {
        List {
            ForEach(viewModel.objects, id: \.id) { object in
                VStack(alignment: .leading) {
                    CachedAsyncImage(url: URL(string: "https://kyiv.ua.museum-digital.org/" + object.image), urlCache: .imageCache) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(height: CGFloat(object.image_height))
                        case .failure(_):
                            Image(systemName: "photo").frame(height: CGFloat(object.image_height))
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    NavigationLink(destination: ObjectDetailView(viewModel: ObjectDetailViewModel(objectId: object.id))) {
                        Text(object.objekt_name)
                    }
                }
            }
            if viewModel.canLoadMore {
                Button("Load More", action: viewModel.loadMoreObjects)
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Об'єкти")
    }
}
