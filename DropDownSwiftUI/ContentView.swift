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

struct DropDown: View {
    
    /// - Drop Down Properties
    var options: [String]
    @Binding var selection: String
    var activeTint: Color
    var inActiveTint: Color
    var dynamic = false

    /// - View Properties
    @State private var expandView = false
    private let optionHeight: CGFloat = 55
    
    var body: some View {
        GeometryReader {
            let size = $0.size

            VStack(alignment: .leading, spacing: 0) {
                
                if dynamic {
                    ForEach(options, id: \.self) { option in
                        RowView(option, size: size)
                    }
                } else {
                    RowView(selection, size: size)

                    ForEach(options.filter { $0 != selection }, id: \.self) { option in
                        RowView(option, size: size)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(inActiveTint)
            )
            .offset(y: offset())
           
        }
        .frame(height: optionHeight)
        .overlay(alignment: .trailing) {
            Image(systemName: "chevron.up.chevron.down")
                .padding(.trailing, 10)
        }
        .mask(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: expandView ? CGFloat(options.count) * optionHeight : optionHeight)
                .offset(y: offsetMask())
        }
    }
    
    // 選択した optionのoffsetYをcurrentPositionにするため
    private func offset() -> CGFloat {
        dynamic ? CGFloat(options.firstIndex(of: selection) ?? 0) * -optionHeight : 0
    }
    // 選択した optionのoffsetYをcurrentPositionにするため
    private func offsetMask() -> CGFloat {
        if dynamic {
            return expandView ? CGFloat(options.firstIndex(of: selection) ?? 0) * -optionHeight : 0
        } else {
            return 0
        }
    }
    
    @ViewBuilder
    func RowView(_ title: String, size: CGSize) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .frame(width: size.width, height: size.height, alignment: .leading)
            .background {
                if selection == title {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(activeTint)
                        .transition(.identity)
                }
            }
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                    if expandView {
                        expandView = false
                        
                        if dynamic {
                            selection = title
                        } else {
                            // 選択したoptionタイトルが同時にanimationされるのを避け、選択した0.25秒後に反映されるように調整
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                selection = title
                            }
                        }
                    } else {
                        expandView = true
                    }
                }
            }
    }
}
