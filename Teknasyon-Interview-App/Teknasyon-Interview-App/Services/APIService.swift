//
//  APIService.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 10.11.2023.
//

import Foundation



enum APIError: Error {
    case networkError(Error)
    case dataNotFound
    case decodingError(Error)
}



class APIManager {
    static let shared = APIManager()

    private init() {}

    func performSearch(with searchTerm: String, completion: @escaping (Result<[Movie], APIError>) -> Void) {
        
        let urlString = "\(APIConstants.baseURL)?apikey=\(APIConstants.apiKey)&s=\(searchTerm)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(.networkError(NSError())))
                    return
                }

                guard let data = data else {
                    let dataError = NSError(domain: "APIManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"])
                    completion(.failure(.dataNotFound))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(SearchResults.self, from: data)
                    let movies = searchResults.search

                   
                    DispatchQueue.main.async {
                        completion(.success(movies))
                    }
                } catch let error {
                   
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError(error)))
                    }
                }
            }

            task.resume()
        }
    }
    
    func fetchMovies(page: Int, filter: String, completion: @escaping (Result<[Movie], APIError>) -> Void) {
        
        let urlString = "\(APIConstants.baseURL)?apikey=\(APIConstants.apiKey)&s=\(filter)&page=\(page)"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(.networkError(NSError())))
                    return
                }

                guard let data = data else {
                    let dataError = NSError(domain: "APIManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"])
                    completion(.failure(.dataNotFound))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let searchResults = try decoder.decode(SearchResults.self, from: data)
                    let movies = searchResults.search

                    DispatchQueue.main.async {
                        completion(.success(movies))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError(error)))
                    }
                }
            }

            task.resume()
        }
    }


    func fetchImage(for urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(.networkError(error)))
                    return
                }

                guard let data = data else {
                    let dataError = NSError(domain: "APIManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"])
                    completion(.failure(.dataNotFound))
                    return
                }

                completion(.success(data))
            }

            task.resume()
        }
    }
}

