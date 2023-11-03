//
//  RickAndMortyAPIRepository.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 6/9/23.
//

import Foundation

enum FactorError: Error {
    case url
    case data
}

class RickAndMortyAPIRepository: RickAndMortyRepository {
    
    func getCharacters(completion: @escaping (Result<Characters, FactorError>) -> ()) {
        guard let url = URL(string: Constants.EndPoints.characters) else {
            return completion(Result.failure(.url))
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: url) { data, response, error in
            do {
                guard let data = data, let response = try? JSONDecoder().decode(Characters.self, from: data)
                    else { return completion(Result.failure(.data)) }

                completion(Result.success(response))
            }
        }.resume()
    }
    
    func getEpisode(episode: String, completion: @escaping (Result<Episode, FactorError>) -> ()) {
        guard let url = URL(string: episode) else {
            return completion(Result.failure(.url))
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        urlSession.dataTask(with: url) { data, response, error in
            do {
                guard let data = data, let response = try? JSONDecoder().decode(Episode.self, from: data)
                    else { return completion(Result.failure(.data)) }

                completion(Result.success(response))
            }
        }.resume()
    }
}
