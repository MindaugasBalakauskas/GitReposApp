//
//  FakeApiTask.swift
//  GitReposTests
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation
@testable import GitRepos

class FakeApiTask: ApiProtocol {
    
    var responceType: String = ""
    func request(_ httpMethod: HttpMethod, request: Request, completion: @escaping (Data?, Int, Error?) -> Void) {
        
        let bundle = Bundle(for:FakeApiTask.self)
        
        if responceType == "file_not_found_status_code_404" {
            completion(nil, 404, nil)
            return
        }
        if responceType == "internal_server_error_status_code_500" {
            completion(nil, 500, nil)
            return
        }
        
        guard let url = bundle.url(forResource: responceType, withExtension:"json"),
              let data = try? Data(contentsOf: url) else {
                  completion(nil, 200, ApiError.recieveNilResponse)
                  return
              }
        
            
        completion(data, 200  , nil)

    }
}
