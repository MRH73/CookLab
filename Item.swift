//
//  Item.swift
//  CookLab
//
//  Created by Miguel Ruiz on 18/5/25.
//

import Foundation

struct Item: Identifiable {
    let id = UUID()
    var timestamp: Date = .now
}
