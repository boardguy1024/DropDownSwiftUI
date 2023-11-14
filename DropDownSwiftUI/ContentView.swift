//
//  ContentView.swift
//  DropDownSwiftUI
//
//  Created by park kyung seok on 2023/11/14.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = "Easy"
    
    var body: some View {
        VStack {
            DropDown(options: ["Easy", "Normal", "Hard", "Expect"],
                     selection: $selection,
                     activeTint: .primary.opacity(0.1),
                     inActiveTint: .white.opacity(0.05))
            .frame(width: 130)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .environment(\.colorScheme, .dark)
        .background(Color.black.opacity(0.8))
    }
}

#Preview {
    ContentView()
}
