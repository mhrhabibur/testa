//
//  APIService.swift
//  StarWars
//
//  Created by Habibur Rahman on 4/29/24.
//

import Foundation

import UIKit
import Alamofire

class ApiService {

    public static let sharedInstance = ApiService()

    public func fetchAPIRequest<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: JSONEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        completion: @escaping (T?, ApiServiceError?) ->()) {
        if !NetworkChecking.sharedInstance.isNetworkAvailable {
            completion(nil, .network)
            return
        }
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(T.self, from: data)
                    completion(decodedResponse, nil)
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                    completion(nil, .decode)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(nil, .decode)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(nil, .decode)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(nil, .decode)
                } catch {
                    print("error: ", error)
                    completion(nil, .decode)
                }
            case .failure(let error):
                completion(nil, .error(message: error.localizedDescription))
            }
        }
        }
}


public typealias Parameters = [String: String]

public extension URLRequest {

    func encode(with parameters: Parameters?) -> URLRequest {
        guard let parameters = parameters else {
            return self
        }
        var encodedURLRequest = self

        if let url = self.url, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            var newUrlComponents = urlComponents
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            newUrlComponents.queryItems = queryItems
            encodedURLRequest.url = newUrlComponents.url
            return encodedURLRequest
        } else {
            return self
        }
    }
}

public enum ApiServiceError: Error {
    case error(message: String)
    case httpCode(statusCode: Int)
    case network
    case fetch
    case decode
    case other

    var reason: String {
        switch self {
        case .error(message: let message):
            return message
        case .httpCode(statusCode: let statusCode):
            return "The call failed with HTTP code\(statusCode)"
        case .network:
            return "The internet connection is lost"
        case .fetch:
            return "Failed to fetch data"
        case .decode:
            return "Failed to decode json"
        case .other:
            return "Unfortunately something went wrong"
        }
    }
}

public struct ErrorResponse: Hashable, Codable {
    public var message: String

    public enum CodingKeys: String, CodingKey {
        case message = "Message"
    }
    public init(error: ErrorResponse) {
        message = error.message
    }
}

public extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}

