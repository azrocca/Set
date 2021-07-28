//
//  UtilityExtensions.swift
//  Set
//
//  Created by Rocca on 7/26/21.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
