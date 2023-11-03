//
//  ManageStarsReviews.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 6/9/23.
//

import Foundation

class ManagerStarsReviews: ManageStarsReviewsProtocol {
    
    static var shared = ManagerStarsReviews()
    
    func saveRatingsBy(id: Int, stars: Int) {
        UserDefaults.standard.set(stars, forKey: String(describing: id))
    }
    
    func getRatingsBy(id: Int?) -> Int {
        guard let id = id else { return 0}
        return UserDefaults.standard.integer(forKey: String(describing: id))
    }
}
