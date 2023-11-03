//
//  StarsReview.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 6/9/23.
//

import UIKit

protocol StarsReviewsDelegate: AnyObject {
    func sendReview(stars: Int)
}

class StarsReviews: UIView {

    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    weak var delegate: StarsReviewsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        build()
    }
    
    @objc func handleTap(_ sender: UIButton?) {
        guard let btn = sender, let identifier = Int(btn.accessibilityIdentifier ?? "0") else { return }
        
        setStars(stars: identifier)
        delegate?.sendReview(stars: identifier)
    }
    
    private func build() {
        let nib = UINib(nibName: "StarsReviews", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        addSubview(view)
        
        star1.addTarget(self, action: #selector(handleTap(_:)), for:.touchUpInside)
        star2.addTarget(self, action: #selector(handleTap(_:)), for:.touchUpInside)
        star3.addTarget(self, action: #selector(handleTap(_:)), for:.touchUpInside)
        star4.addTarget(self, action: #selector(handleTap(_:)), for:.touchUpInside)
        star5.addTarget(self, action: #selector(handleTap(_:)), for:.touchUpInside)

        star1.accessibilityIdentifier = String(describing: "1")
        star2.accessibilityIdentifier = String(describing: "2")
        star3.accessibilityIdentifier = String(describing: "3")
        star4.accessibilityIdentifier = String(describing: "4")
        star5.accessibilityIdentifier = String(describing: "5")
    }
    
    private func setStars(stars: Int) {
        let colorSelected: UIColor = UIColor(named: Constants.AssetColors.starColor) ?? .yellow
        let starSelected: UIImage? = UIImage(systemName: "star.fill")?.withTintColor(colorSelected).withRenderingMode(.alwaysOriginal)
        let starUnSelected: UIImage? = UIImage(systemName: "star")?.withTintColor(.gray).withRenderingMode(.alwaysOriginal)

        star1.setImage(stars >= 1 ? starSelected : starUnSelected, for: .normal)
        star2.setImage(stars >= 2 ? starSelected : starUnSelected, for: .normal)
        star3.setImage(stars >= 3 ? starSelected : starUnSelected, for: .normal)
        star4.setImage(stars >= 4 ? starSelected : starUnSelected, for: .normal)
        star5.setImage(stars >= 5 ? starSelected : starUnSelected, for: .normal)
    }
    
    func updateUI(stars: Int) {
        setStars(stars: stars)
    }
}
