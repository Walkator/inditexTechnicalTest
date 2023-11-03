//
//  RickAndMortyRepository.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 6/9/23.
//

import Foundation

protocol RickAndMortyRepository {
    func getCharacters(completion: @escaping (Result<Characters, FactorError>) -> ())
    func getEpisode(episode: String, completion: @escaping (Result<Episode, FactorError>) -> ())
}
