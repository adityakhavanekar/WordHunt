//
//  NetworkManager.swift
//  WordHunt
//
//  Created by APPLE on 19/05/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class NetworkManager{
    
    private init(){}
    
    static let shared = NetworkManager()
    
    func request(url: URL, method: HTTPMethod = .get, params: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let params = params {
            var components = URLComponents(string: url.absoluteString)
            components?.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
            
            request.url = components?.url
        }
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "UnknownError", code: -1, userInfo: nil)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

