//
//  NetworkManager.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 15.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import Foundation

class NetworkManager {

    public static let instance = NetworkManager()
    
    private init() { }
    
    func request(searchingPhoto: String, callBack: @escaping(Data?, URLResponse?, Error?) -> Void) {
        let parameters = self.prepareParameters(searchWord: searchingPhoto)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.prepareHeaders()
        request.httpMethod = "GET"
        let task = self.createDataTask(from: request, callBack: callBack)
        task.resume()
    }
    
    private func prepareParameters(searchWord: String?) -> [String:String] {
        var parameters = [String:String]()
        parameters["query"] = searchWord
        parameters["page"] = String(1)
        parameters["per_page"] = String(5)
        return parameters
    }
    
    private func url(params: [String:String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func prepareHeaders() -> [String:String] {
        var headers = [String:String]()
        headers["Authorization"] = "Client-ID 9854adf3c8c24f42c23b2fc3855c2bbfe82eed43fd79387a3cdbc441eb3537c4"
        return headers
    }
    
    private func createDataTask(from request: URLRequest, callBack: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                callBack(data, response, error)
            }
        }
    }
    
    
}
