//
//  Info.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 5/9/23.
//

import Foundation

struct Info: Decodable {
    var count: Int?
    var pages: Int?
    var next: String?
    var prev: String?
}
