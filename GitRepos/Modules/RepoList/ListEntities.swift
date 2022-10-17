//
//  ListEntities.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation

struct ListEntryEntity {
    let language: String
}

final class ListEntities {
    let entryEntity: ListEntryEntity

    var gitHubRepositories: [GitHubRepository] = []

    class SearchApiState {
        var pageCount = 1
        var isFetching = false
    }

    var searchApiState = SearchApiState()

    init(entryEntity: ListEntryEntity) {
        self.entryEntity = entryEntity
    }
}
