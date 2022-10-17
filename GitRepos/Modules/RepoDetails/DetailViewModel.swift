//
//  DetailViewModel.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation

final class DetailViewModel {
    
    internal var entities: DetailEntities
    private weak var view: DetailViewInputs!
    
    init(entities: DetailEntities,
         view: DetailViewInputs) {
        self.view = view
        self.entities = entities
    }
}
