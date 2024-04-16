//
//  FeatureView.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 04.04.2024.
//

import SwiftUI

struct FeatureView: View {
    var featureName: String
    var isAvailable: Bool

    var body: some View {
        HStack {
            Text(featureName)
            Spacer()
            Image(systemName: isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isAvailable ? .green : .red)
        }
        .padding(.horizontal)
    }
}
