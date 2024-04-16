//
//  SubcollectionVM.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 03.04.2024.
//

import Foundation

class SubcollectionViewModel: ObservableObject {
    @Published var subcollection: Subcollection

    init(subcollection: Subcollection) {
        self.subcollection = subcollection
    }
}
