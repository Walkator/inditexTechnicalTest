//
//  CharacterCollectionCell.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 5/9/23.
//

import UIKit

class CharacterCollectionCell: UICollectionViewCell {

    @IBOutlet weak var viewStar: UIView!
    @IBOutlet weak var star: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    private var idCell: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    private func setStyle() {
        self.layer.cornerRadius = 25
        
        imageView.contentMode = .scaleToFill
        
        nameText.textAlignment = .center
        nameText.textColor = .white
        nameText.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        nameText.numberOfLines = 2
        nameText.lineBreakMode = .byWordWrapping
        nameText.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        viewStar.isHidden = true
        viewStar.backgroundColor = .black.withAlphaComponent(0.5)
        viewStar.layer.cornerRadius = 18
        
        star.image = UIImage(systemName: "star.fill")?.withTintColor(UIColor(named: Constants.AssetColors.starColor) ?? .yellow).withRenderingMode(.alwaysOriginal)
    }

    func updateUI(data: CharacterCollectionCellModel) {
        idCell = data.id
        imageView.loadImageUsingCache(withUrl: data.image)
        nameText.text = data.name
        viewStar.isHidden = data.stars == 0
    }
    
    func getID() -> Int? {
        return idCell
    }
}
