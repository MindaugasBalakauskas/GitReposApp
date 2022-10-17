//
//  Routerable.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation

protocol Routerable {
    var view: Viewable! { get }
    func pop(animated: Bool)
}

extension Routerable {
    func pop(animated: Bool) {
        view.pop(animated: animated)
    }
}
