//
//  AspectVGrid.swift
//  Set
//
//  Created by Rocca on 7/11/21.
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var aspectRatio: CGFloat
    var minWidth: CGFloat
    @ViewBuilder var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, minWidth: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.minWidth = minWidth
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio, minWidth: minWidth)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: width), spacing: 0)], spacing: 0) {
                        ForEach(items, id: \.id) { item in
                            content(item)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
    }
        
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat, minWidth: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        if floor(size.width / CGFloat(columnCount)) >= minWidth {
            return floor(size.width / CGFloat(columnCount))
        } else {
            return minWidth
        }
    }
}
