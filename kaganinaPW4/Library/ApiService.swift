//
//  ApiService.swift
//  kaganinaPW5
//

import Foundation

class ApiService {
    static let shared = ApiService()
    
    enum ApiError: Error {
        case error(_ errorString: String)
    }
    
    let source = "https://newsapi.org/v2/top-headlines?country=ru&apiKey=514f26a474024d3d93cd9e4f2b72cf94"
    //let source = "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=514f26a474024d3d93cd9e4f2b72cf94"
    
    func getTopStories(completion: @escaping (Result<News,ApiError>) -> Void) {
        guard let url = URL(string: source) else {
            completion(.failure(ApiError.error("cannot get url")))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(ApiError.error(error.localizedDescription)))
                return
            }
            guard let data = data else {
                completion(.failure(ApiError.error("bad data")))
                return
            }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(News.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(ApiError.error("Error: \(decodingError.localizedDescription)")))
            }
        }.resume()
    }
}
