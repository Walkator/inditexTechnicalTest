//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 5/9/23.
//

import Foundation

struct Character: Decodable {
    var id: Int?
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin: Origin?
    var location: Location?
    var image: String?
    var episode: [String?]
    var url: String?
    var created: String?
}
