//
//  EpisodeViewCell.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 6/9/23.
//

import UIKit

class EpisodeViewCell: UITableViewCell {

    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    private func setStyle() {
        episodeLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 1
    }
    
    func updateUI(data: EpisodeViewCellModel) {
        episodeLabel.text = data.episode
        nameLabel.text = data.name
    }
}
