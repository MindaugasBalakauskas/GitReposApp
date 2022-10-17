//
//  GitHubApi.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation


protocol GitHubApiType {
    func search(with request: SearchLanguageRequest, completion:@escaping((Result<SearchRepositoriesResponse, ApiError>) -> Void))
}

struct SearchLanguageRequest: Request {
    private let baseUrl = "https://api.github.com"

    var url: String {
        return baseUrl + "/search/repositories"
    }
    let language: String
    let page: Int
    
    func params() -> [(key: String, value: String)] {
        return [
            (key: "q", value: language),
            (key: "sort", value : "stars"),
            (key: "page", value : "\(page)")
        ]
    }
}

struct GitHubApi: GitHubApiType {
  
    let apiTask: ApiProtocol
    
    func search(with request: SearchLanguageRequest, completion: @escaping((Result<SearchRepositoriesResponse, ApiError>) -> Void)) {
       
        apiTask.request(.get, request: request) { data, statusCode, error in
           
            if let error = error {
                completion(.failure(ApiError.recieveErrorHttpStatus))
                return
            }
            if let responseError = ApiTask.check(statusCode: statusCode) {
                completion(.failure(responseError))
                return
            }
            guard let data = data else {
                completion(.failure(ApiError.recieveNilBody))
                return
            }
            
            do {
                let response = try self.parse(data)
                completion(.success(response))
            } catch {
                completion(.failure(ApiError.failedParse))
            }
        }
       
    }

    private func parse(_ data: Data) throws -> SearchRepositoriesResponse {
        let response: SearchRepositoriesResponse = try JSONDecoder().decode(SearchRepositoriesResponse.self, from: data)
        return response
    }
    
    
}
