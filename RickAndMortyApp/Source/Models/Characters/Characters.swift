//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 5/9/23.
//

import Foundation

struct Characters: Decodable {
    var info: Info?
    var results: [Character?]
}
