//
//  ObjectDetailView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.04.2024.
//

import SwiftUI

struct ObjectDetailView: View {
    @ObservedObject var viewModel: ObjectDetailViewModel
    
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
                
                Text("Схожість: \(viewModel.similarityScore ?? 100, specifier: "%.2f")")
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.top, 10)
            }
        }
        .onAppear {
            viewModel.fetchObjectDetail()
        }
        .navigationTitle("Про об'єкт")
    }
}


