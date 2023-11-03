//
//  ManageStarsReviewsProtocol.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 6/9/23.
//

import Foundation

protocol ManageStarsReviewsProtocol {
    func saveRatingsBy(id: Int, stars: Int)
    func getRatingsBy(id: Int?) -> Int
}
