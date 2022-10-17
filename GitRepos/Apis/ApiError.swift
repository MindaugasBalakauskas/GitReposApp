//
//  ApiError.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation

enum ApiError: Error , Equatable {
    case recieveNilResponse
    case recieveErrorHttpStatus
    case recieveNilBody
    case failedParse
    case customError(Int)
}
