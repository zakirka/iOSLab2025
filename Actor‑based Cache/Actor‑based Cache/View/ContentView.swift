//
//  ContentView.swift
//  Actor‑based Cache
//
//  Created by Azamat Zakirov on 19.04.2026.
//

import SwiftUI
import UIComponents

struct ContentView: View {
    
    var body: some View {
        VStack {
            Loading()
                .padding()
            ProfileRepresentable()
                .frame(height: 400)
                .background(Color.yellow.opacity(0.1))
            
            Spacer()
        }
        
    }
}
