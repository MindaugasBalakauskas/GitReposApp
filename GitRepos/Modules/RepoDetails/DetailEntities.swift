//
//  DetailEntities.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation
struct DetailEntryEntity {
    let gitHubRepository: GitHubRepository
    init(gitHubRepository: GitHubRepository) {
        self.gitHubRepository = gitHubRepository
    }
}

struct DetailEntities {
    let entryEntity: DetailEntryEntity

    init(entryEntity: DetailEntryEntity) {
        self.entryEntity = entryEntity
    }
}
