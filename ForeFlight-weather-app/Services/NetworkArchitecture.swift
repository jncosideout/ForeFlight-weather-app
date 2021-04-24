//
//  NetworkArchitecture.swift
//  ForeFlight-weather-app
//
//  Created by Alexander Scott Beaty on 4/23/21.
//
import Foundation

enum NetworkArchError: Error {
    case invalidResponse(Int?)
    case noData
    case failedRequest(Error?)
    case invalidData
    case wrongMIME
}

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    /// for GET requests
    func load(_ url: URL,_ httpMethod: String,_ headers: [String:String], withCompletion completion: @escaping (ModelType?, NetworkArchError?) -> Void)
    /// for POST requests
    func post(_ url: URL, _ headers: [String:String], from jsonData: Data, withCompletion completion: @escaping (ModelType?, NetworkArchError?) -> Void)
}

extension NetworkRequest {
    func load(_ url: URL,_ httpMethod: String,_ headers: [String:String], withCompletion completion: @escaping (ModelType?, NetworkArchError?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        for header in headers {
            request.setValue(header.1, forHTTPHeaderField: header.0)
        }
        let task = session.dataTask(with: request) { data, response, error in

            if let error = error {
                print("Failed request: \(error.localizedDescription)")
                completion(nil, .failedRequest(error))
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(nil, .noData)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Unable to process response")
                completion(nil, .invalidResponse(nil))
                return
            }

            guard (200...299).contains(response.statusCode) else {
                print("Failure response: \(response.statusCode)")
                completion(nil, .invalidResponse(response.statusCode))
                return
            }

            completion(self.decode(data), nil)
        }
        task.resume()
    }

    func post(_ url: URL, _ headers: [String:String], from jsonData: Data, withCompletion completion: @escaping (ModelType?, NetworkArchError?) -> Void) {

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        for header in headers {
            request.setValue(header.1, forHTTPHeaderField: header.0)
        }
        let mimeType = request.value(forHTTPHeaderField: "accept")

        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in

            if let error = error {
                print("Failed request: \(error.localizedDescription)")
                completion(nil, .failedRequest(error))
                return
            }

            guard let data = data else {
                print("No data returned")
                completion(nil, .noData)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                print("Unable to process response")
                completion(nil, .invalidResponse(nil))
                return
            }

            guard (200...299).contains(response.statusCode) else {
                print("Failure response: \(response.statusCode)")
                completion(nil, .invalidResponse(response.statusCode))
                return
            }

            if let respMime = response.mimeType, let mimeType = mimeType, respMime != mimeType {
                print("Wrong MIME type")
                completion(nil, .wrongMIME)
                return
            }

            completion(self.decode(data), nil)
        }
        task.resume()
    }
}

//MARK: - APIRequest GET

/// Can be used by itself for GET requests but it is the base of most API requests
class APIRequest<Resource: APIResource> {
    var resource: Resource
    //typealias is inferred by the return type of decode(_:)
    init(resource: Resource) {
        self.resource = resource
    }
}

extension APIRequest: NetworkRequest {
    func decode(_ data: Data) -> Resource.ModelType? {
        // The type passed to decode(_:from:) must match the associated type of APIRequest
        // It should be the same as the type of parameter in the completion passed to load(withCompletion:)
        let model = try? JSONDecoder().decode(Resource.ModelType.self, from: data)
        return model
    }

    func load(_ httpMethod: String = "GET", withCompletion completion: @escaping (Resource.ModelType?, NetworkArchError?) -> Void) {
        load(resource.url, httpMethod, resource.customHeaders, withCompletion: completion)
    }
}

protocol APIResource {
    associatedtype ModelType: Decodable
    var endpoint: String { get }
    var host: String { get }
    var queryItems: [URLQueryItem] { get }
    var customHeaders: [String:String] { get }
}

extension APIResource {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = endpoint
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        return components.url ?? URL(string: "https://google.com")!
    }
}

//MARK: - POST request

/// Specifically used for POST requests which contain serialized JSON and custom headers
class PostRequest<Resource: PostAPIResource>: APIRequest<Resource> {
    func post(withCompletion completion: @escaping (Resource.ModelType?, NetworkArchError?) -> Void) {
        post(resource.url, resource.customHeaders, from: resource.jsonBody, withCompletion: completion)
    }
}

protocol PostAPIResource: APIResource {
    var jsonBody: Data { get }
    var customHeaders: [String:String] { get }
}
