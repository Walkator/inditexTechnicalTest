//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 5/9/23.
//

import Foundation

struct Episode: Decodable {
    var id: Int?
    var name: String?
    var air_date: String?
    var episode: String?
    var characters: [String?]
    var url: String?
    var created: String?
}
