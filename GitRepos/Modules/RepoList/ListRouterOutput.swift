//
//  ListRouterOutput.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation
import UIKit

struct ListRouterInput {

    func view(entryEntity: ListEntryEntity, gitHubApi: GitHubApiType) -> ListViewController {
        let view = ListViewController()
        let viewModel = ListViewModel(gitHubApi: gitHubApi, entities: ListEntities(entryEntity: entryEntity), view: view)
        view.viewModel = viewModel
        view.router = ListRouterOutput(view)
        return view
    }
}

final class ListRouterOutput: Routerable {

    private(set) weak var view: Viewable!

    init(_ view: Viewable) {
        self.view = view
    }

    func transitionDetail(gitHubRepository: GitHubRepository) {
        DetailRouterInput().push(from: view, entryEntity: DetailEntryEntity(gitHubRepository: gitHubRepository))
    }
}
