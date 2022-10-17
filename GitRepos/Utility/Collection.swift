//
//  Collection.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
