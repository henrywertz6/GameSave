//
//  StarRatingSlider.swift
//  GameTracker
//
//  Created by Henry Wertz on 3/25/24.
//

import Foundation
import SwiftUI

public struct StarRatingSlider<Content>: View where Content: View {
    @Binding public var count: Double
    var minimum: Int = 0
    var maximum: Int = 5
    var spacing: CGFloat = 8
    @ViewBuilder var content: (Bool, Int) -> Content
    
    @State private var starWidth: CGFloat = 0
    
    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<maximum, id: \.self) { i in
                content(Double(i) < count, i)
                    .contentSize(width: $starWidth)
                    .onTapGesture {
                        count = Double(i + 1)
                    }
            }
        }
        .gesture(
            DragGesture().onChanged(changeDragGesture(value:))
        )
    }
    
    private func changeDragGesture(value: DragGesture.Value) {
        let maximum = Double(maximum)
        let minimum = Double(minimum)
        let starWidth = self.starWidth
        let spacing = self.spacing
        
        let offset = value.location.x * 1.5
        if offset < 0 {
            return
        }
        
        
        let value = offset / (starWidth + spacing)
        let wholePart = Double(Int(value))
        let fractionalPart = fmod(value, 1.0)
        
        self.count = wholePart + (fractionalPart > 0.5 ? 0.5 : 0.0)
        
        if self.count < minimum {
            self.count = minimum
        } else if self.count > maximum {
            self.count = maximum
        }
    }
}
