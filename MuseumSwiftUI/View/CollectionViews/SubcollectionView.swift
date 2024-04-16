//
//  SubcollectionView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 02.04.2024.
//

import SwiftUI

struct SubcollectionView: View {
    @ObservedObject var viewModel: SubcollectionViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: viewModel.subcollection.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 180, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .imageScale(.large)
                    } else {
                        ProgressView()
                    }
                }
                .padding()

                Group {
                    Text(viewModel.subcollection.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)

                    Text("Кількість об'єктів: \(viewModel.subcollection.numberOfObjects)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

                Text(viewModel.subcollection.description)
                    .padding()
                    .background(Color(UIColor.systemBackground).opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 3)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Розділ")
    }
}

