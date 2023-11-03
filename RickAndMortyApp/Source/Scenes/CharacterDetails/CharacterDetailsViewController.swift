//
//  CharacterDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 6/9/23.
//

import UIKit

protocol CharacterDetailsDelegate: AnyObject {
    func didDismiss()
}

protocol CharacterDetailsPresenterDelegate: AnyObject {
    func setupView()
    func getNumberOfCells() -> Int
    func getCellBy(row: Int) -> EpisodeViewCellModel?
    func sendReview(stars: Int)
}

class CharacterDetailsViewController: UIViewController {

    @IBOutlet weak var closeIconBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var starsReview: StarsReviews!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: CharacterDetailsDelegate?
    var presenter: CharacterDetailsPresenterDelegate?
    var dataStore: CharacterDetailsDataStore?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupPresenter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didDismiss()
    }
    
    @IBAction func touchInsideCloseIconBtn(_ sender: Any) {
        navigateToBack()
    }
    
    func setupPresenter() {
        let setupPresenter = CharacterDetailsPresenter()
        setupPresenter.view = self
        self.dataStore = setupPresenter
        presenter = setupPresenter
    }
}

extension CharacterDetailsViewController: CharacterDetailsViewDelegate {
    
    func setupView() {
        view.backgroundColor = UIColor(named: Constants.AssetColors.themeColor)
        closeIconBtn.backgroundColor = .init(white: 1, alpha: 0.4)
        closeIconBtn.layer.cornerRadius = 16
        closeIconBtn.setImage(UIImage(systemName: "xmark")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), for: .normal)
        
        imageView.contentMode = .scaleAspectFill
        
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
        
        starsReview.delegate = self
        
        tableView.backgroundColor = UIColor(named: Constants.AssetColors.themeColor)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: EpisodeViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EpisodeViewCell.self))
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setImage(image: String) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.loadImageUsingCache(withUrl: image)
        }
    }
    
    func setStars(numStars: Int) {
        starsReview.updateUI(stars: numStars)
    }
    
    func setNameCharacter(name: String) {
        nameLabel.text = name
    }
    
    func setGender(gender: String) {
        genderLabel.text = "Gender: \(gender)"
    }
    
    func setStatus(status: String) {
        statusLabel.text = "Status: \(status)"
    }
    
    func setLocation(location: String) {
        locationLabel.text = "Location: \(location)"
    }
    
    func setOrigin(origin: String) {
        originLabel.text = "Origin: \(origin)"
    }
}

extension CharacterDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfCells() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataCell = presenter?.getCellBy(row: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EpisodeViewCell.self), for: indexPath) as? EpisodeViewCell
              else { return UITableViewCell() }


        cell.updateUI(data: dataCell)

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 36))
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: headerView.frame.width, height: headerView.frame.height))
        
        label.text = NSLocalizedString("characterDetail.table.header", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 24)
        
        headerView.backgroundColor = UIColor(named: Constants.AssetColors.themeColor)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}

extension CharacterDetailsViewController: StarsReviewsDelegate {
    
    func sendReview(stars: Int) {
        presenter?.sendReview(stars: stars)
    }
}

protocol CharacterDetailsRouterDelegate: AnyObject {
    func navigateToBack()
}

extension CharacterDetailsViewController: CharacterDetailsRouterDelegate {
    
    func navigateToBack() {
        delegate?.didDismiss()
        dismiss(animated: true)
    }
}
