//
//  UserProfileView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 18.04.2024.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject private var viewModel = UserProfileVM.shared
    
    var body: some View {
//        NavigationView {
            List {
                Section(header: Text("Додати новий інтерес")) {
                    HStack {
                        TextField("Введіть інтерес", text: $viewModel.inputInterest)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            viewModel.addInterest()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                Section(header: Text("Ваші інтереси")) {
                    ForEach(viewModel.userProfile.interests, id: \.self) { interest in
                        Text(interest)
                    }
                    .onDelete(perform: viewModel.removeInterest)
                }
                
//                Button("Отримати рекомендацію музею") {
//                    viewModel.getRecommendation()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//
//                if let institution = viewModel.recommendedInstitution {
//                    NavigationLink(destination: InstitutionDetailView(viewModel: InstitutionDetailViewModel(institutionId: institution.id, userProfileVM: UserProfileVM.shared))) {
//                        Text("Переглянути рекомендацію")
//                            .foregroundColor(.blue)
//                    }
//                }
            }
            .navigationTitle("Профіль")
//        }
    }
}

