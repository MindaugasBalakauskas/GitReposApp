//
//  DetailRouter.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation

struct DetailRouterInput {

    private func view(entryEntity: DetailEntryEntity) -> DetailViewController {
        let view = DetailViewController()
        view.viewModel = DetailViewModel(entities: DetailEntities(entryEntity: entryEntity), view: view)
        return view
    }

    func push(from: Viewable, entryEntity: DetailEntryEntity) {
        let view = self.view(entryEntity: entryEntity)
        from.push(view, animated: true)
    }

}

final class DetailRouterOutput: Routerable {

    private(set) weak var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }

}

