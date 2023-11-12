//
//  APIService.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 10.11.2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    private init() {}

    func performSearch(with searchTerm: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let apiKey = "61d8762c"
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchTerm)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    let dataError = NSError(domain: "APIManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"])
                    completion(.failure(dataError))
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
                        completion(.failure(error))
                    }
                }
            }

            task.resume()
        }
    }
    
    func fetchMovies(page: Int, filter: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let apiKey = "61d8762c"
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(filter)&page=\(page)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    let dataError = NSError(domain: "APIManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"])
                    completion(.failure(dataError))
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
                        completion(.failure(error))
                    }
                }
            }

            task.resume()
        }
    }


    func fetchImage(for urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    let dataError = NSError(domain: "APIManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"])
                    completion(.failure(dataError))
                    return
                }

                completion(.success(data))
            }

            task.resume()
        }
    }
}

