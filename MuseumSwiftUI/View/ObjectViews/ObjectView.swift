//
//  ObjectView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 03.04.2024.
//

import SwiftUI
import CachedAsyncImage

struct ObjectView: View {
    @ObservedObject var viewModel: ObjectViewModel

    var body: some View {
        List(viewModel.objects) { object in
            VStack(alignment: .leading) {
                CachedAsyncImage(url: URL(string: "https://kyiv.ua.museum-digital.org/" + object.image), urlCache: .imageCache) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: CGFloat(object.image_height))
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                    } else {
                        ProgressView()
                    }
                }
                NavigationLink(destination: ObjectDetailView(viewModel: ObjectDetailViewModel(objectId: object.id, userProfileVM: UserProfileVM.shared))) {
                    Text(object.objekt_name)
                }
            }
        }
        .navigationTitle("Об'єкти")
        
        if viewModel.canLoadMore {
            loadMoreButton
        }

    }
    
    private var loadMoreButton: some View {
        Button("Load More") {
            viewModel.fetchObjects()
        }
        .frame(maxWidth: .infinity)
    }
}


extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}


