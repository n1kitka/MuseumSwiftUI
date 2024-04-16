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
                NavigationLink(destination: ObjectDetailView(viewModel: ObjectDetailViewModel(objectId: object.id))) {
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

//struct ObjectsMainView: View {
//    @ObservedObject var viewModel = AllObjectsViewModel()
//    
//    var body: some View {
//        List {
//            ForEach(viewModel.objects, id: \.id) { object in
//                Section(header: Text(institution.name)) {
//                    ForEach(institution.collections, id: \.id) { collection in
//                        NavigationLink(destination: CollectionDetailView(viewModel: CollectionDetailViewModel(collectionId: collection.id))) {
//                            HStack {
//                                CachedAsyncImage(url: URL(string: collection.image), urlCache: .imageCache) { phase in
//                                    if let image = phase.image {
//                                        image
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 50, height: 50)
//                                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                                    } else if phase.error != nil {
//                                        Image(systemName: "photo")
//                                            .frame(width: 50, height: 50)
//                                    } else {
//                                        ProgressView()
//                                    }
//                                }
//                                .padding(.trailing, 5)
//                                
//                                VStack(alignment: .leading) {
//                                    Text(collection.name)
//                                        .font(.headline)
//                                    Text("\(collection.numberOfObjects) objects")
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .navigationTitle("Collections")
//        
//    }
//}

