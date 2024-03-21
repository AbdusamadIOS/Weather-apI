//
//  NetworkManager.swift
//  Weather app
//
//  Created by Abdusamad Mamasoliyev on 21/03/24.
//

import Foundation

class NetworkManager {
    let defaults = UserDefaults.standard
    static let shared = NetworkManager()
    
    struct EmptyModel: Codable {}
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    func request<T1: Codable, T2: Codable>(
        urlString: String,
        get: T1 = EmptyModel(),
        post: T2 = EmptyModel(),
        httpMethod: HTTPMethod
    ) async throws -> T1? {
        guard let url = URL(string: urlString) else {
            throw BackError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if T2.self != EmptyModel.self {
            let encode = JSONEncoder()
            encode.keyEncodingStrategy = .convertToSnakeCase
            guard let uploadData = try? encode.encode(post) else {
                throw BackError.postError
            }
            request.httpBody = uploadData
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw BackError.invalidResponse
        }
        print("statusCode: \(response.statusCode)")
        
        switch response.statusCode {
        case 400: throw BackError.badRequest
        case 401:
            throw BackError.unauth
        case 404: throw BackError.notFound
        case 422: throw BackError.postError
        case 500...599: throw BackError.server
        default: break
        }
        
        if T1.self == EmptyModel.self {
            return nil
        } else {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T1.self, from: data)
            } catch {
                throw BackError.invalidData
            }
        }
    }
}
