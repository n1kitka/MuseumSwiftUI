//
//  CollectionDetailView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 12.03.2024.
//

import SwiftUI

struct CollectionDetailView: View {
    @ObservedObject var viewModel: CollectionDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: viewModel.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                            .padding(.bottom, 20)
                    } else if phase.error != nil {
                        EmptyView()
                    } else {
                        ProgressView()
                    }
                }
                .padding()
                
                Group {
                    Text(viewModel.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                }
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Image(systemName: viewModel.collection?.isFavorite ?? false ? "star.fill" : "star")
                        .foregroundColor(viewModel.collection?.isFavorite ?? false ? .yellow : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                .imageScale(.large)
                .padding()
                
                Text("Про колекцію")
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                Text(viewModel.description)
                    .padding(.horizontal)
                
                NavigationLink(destination: ObjectView(viewModel: ObjectViewModel(collectionId: viewModel.collectionId))) {
                    Text("Переглянути об'єкти")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
                Text(viewModel.subcollectionsText)
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                ForEach(viewModel.subcollections) { subcollection in
                    NavigationLink(destination: SubcollectionView(viewModel: SubcollectionViewModel(subcollection: subcollection))) {
                        HStack {
                            AsyncImage(url: URL(string: subcollection.image)) { phase in
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
                        }
                        .padding(.trailing, 5)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text(subcollection.name)
                                .font(.headline)
                            NavigationLink(destination: ObjectView(viewModel: ObjectViewModel(collectionId: subcollection.id))) {
                                Text("Кількість об'єктів: \(subcollection.numberOfObjects)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Про зібрання")
    }
}




