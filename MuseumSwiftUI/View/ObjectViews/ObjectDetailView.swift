//
//  ObjectDetailView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.04.2024.
//

import SwiftUI

struct ObjectDetailView: View {
    @ObservedObject var viewModel: ObjectDetailViewModel
    @State private var showRecommendedObjects = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                Text(viewModel.name)
                    .font(.title)
                    .padding()
                
                Text("Опис")
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                Text(viewModel.description)
                    .padding(.horizontal)
                
                Text("Матеріали")
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                Text(viewModel.materials)
                    .padding(.horizontal)
                
                Text("Top Words from Object Description")
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                ForEach(viewModel.topWords, id: \.self) { word in
                    Text(word)
                        .padding()
                }
                
            }
        }
        .navigationTitle("Про об'єкт")
        .onAppear {
            viewModel.fetchDetailsAndRecommend()
        }
    }
}

struct RecommendedObjectsView: View {
    @ObservedObject var viewModel: ObjectDetailViewModel

    var body: some View {
        List(viewModel.recommendedObjects, id: \.id) { obj in
            VStack(alignment: .leading) {
                Text(obj.object_name)
                    .font(.headline)
                Text(obj.object_description)
                    .font(.subheadline)
            }
        }
        .navigationTitle("Recommended Objects")
    }
}


