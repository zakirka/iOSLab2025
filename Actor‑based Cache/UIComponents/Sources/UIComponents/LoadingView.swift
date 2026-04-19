//
//  LoadingView.swift
//  UIComponents
//
//  Created by Azamat Zakirov on 19.04.2026.
//

import SwiftUI

public struct Loading: View {

    public init() {}

    public var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)

            Text("Загрузка...")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}
