//
//  MainMenuView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 15.04.2024.
//

import SwiftUI

struct MainMenuView: View {
    @State private var showAppDescription = false
    @State private var showCityDescription = false
    @State private var showFactsAndNumbers = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("kyiv")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()

                    VStack(spacing: 20) {
                        NavigationLink(destination: UserProfileView()) {
                            Text("Профіль")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.75))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: QuizView()) {
                            Text("Музеї")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.75))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }

                        NavigationLink(destination: CollectionsSelectionView()) {
                            Text("Зібрання")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.75))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }

                        NavigationLink(destination: ObjectsMainView(viewModel: AllObjectsViewModel())) {
                            Text("Об'єкти")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.75))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding()

                    DisclosureGroup("Про додаток", isExpanded: $showAppDescription) {
                        Text("Description of the app goes here.")
                            .padding()
                    }
                    .padding()

                    DisclosureGroup("Про Київ", isExpanded: $showCityDescription) {
                        Text("Description of Kyiv goes here.")
                            .padding()
                    }
                    .padding()

                    DisclosureGroup("Факти та числа", isExpanded: $showFactsAndNumbers) {
                        Text("Interesting facts and numbers about Kyiv go here.")
                            .padding()
                    }
                    .padding()
                }
                .navigationBarTitle("Меню", displayMode: .inline)
            }
        }
    }
}
