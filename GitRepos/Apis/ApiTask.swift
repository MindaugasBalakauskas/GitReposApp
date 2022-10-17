//
//  ApiTask.swift
//  GitRepos
//
//  Created by Mindaugas Balakauskas on 16/10/2022.
//

import Foundation

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol Request {
    var url: String { get }
    func params() -> [(key: String, value: String)]
}

protocol ApiProtocol {
    func request(_ httpMethod: HttpMethod, request: Request, completion: @escaping (Data?, Int, Error?) -> Void)
}

open class ApiTask: ApiProtocol {
    func request(_ httpMethod: HttpMethod, request: Request, completion: @escaping (Data?, Int, Error?) -> Void) {
        
        guard let urlRequest = URLRequestCreator.create(httpMethod: httpMethod,
                                                  request: request,
                                                  header: httpHeader,
                                                        timeoutInterval: Constants.timeoutInterval,
                                                        cachePolicy: cachePolicy) else {
            return
        }
        let task = ApiTask.apiTaskSession.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            
            completion(data, (response as! HTTPURLResponse).statusCode, error)
        })
        task.resume()
    }
    

    private let httpHeader: [String: String]? = ["content-type": "application/json"]
    private let cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    static let apiTaskSession: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)

    static internal func check(statusCode: Int) -> ApiError? {
        
        guard (200..<300) ~= statusCode else {
            return ApiError.customError(statusCode)
        }
        return nil
    }
}

public class URLRequestCreator {

    static func create(httpMethod: HttpMethod,
                       request: Request,
                       header: [String: String]?,
                       timeoutInterval: TimeInterval,
                       cachePolicy: URLRequest.CachePolicy) -> URLRequest? {

        var url:URL?
        if httpMethod == .get {
            url = URL(string: appendGetParameter(url: request.url, parameter: URLEncoder.encode(request.params())))
        }
        
        guard let url = url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.cachePolicy = cachePolicy
        if let httpHeader = header {
            httpHeader.forEach {
                urlRequest.setValue($0.1, forHTTPHeaderField: $0.0)
            }
        }
       
        return urlRequest
    }

    static func appendGetParameter(url: String, parameter: String) -> String {
        let separator: String
        if url.contains("?") {
            if ["?", "&"].contains(url.suffix(1)) {
                separator = ""
            } else {
                separator = "&"
            }
        } else {
            separator = "?"
        }
        return [url, parameter].joined(separator: separator)
    }
}

public class URLEncoder {
    public class func encode(_ parameters: [(key: String, value: String)]) -> String {
        let encodedString: String = parameters.compactMap {
            guard let value = $0.value.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return nil }
            return "\($0.key)=\(value)"
            }.joined(separator: "&")
        return encodedString
    }
}
