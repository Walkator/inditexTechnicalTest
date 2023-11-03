//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 5/9/23.
//

import UIKit

protocol InitialPresenterDelegate: AnyObject {
    func setupView()
    func modeOnlyScored()
    func filterByText(text: String)
    func getNumberOfCells() -> Int
    func getCellBy(row: Int) -> CharacterCollectionCellModel?
    func didSelectedCell(id: Int?)
}

class InitialViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    
    var presenter: InitialPresenterDelegate?
    
    override func loadView() {
        super.loadView()
        let setupPresenter = InitialPresenter()
        setupPresenter.view = self
        presenter = setupPresenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupView()
    }
    
    @IBAction func filteredBtn(_ sender: Any) {
        presenter?.modeOnlyScored()
    }
}

extension InitialViewController: InitialViewDelegate {
    
    func setupView() {
        view.backgroundColor = UIColor(named: Constants.AssetColors.themeColor)
        
        searchBar.placeholder = NSLocalizedString("initial.search.placeholder", comment: "")
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor(named: Constants.AssetColors.themeColor)
        navigationBar.topItem?.title = NSLocalizedString("initial.tab.title", comment: "")

        filterBtn.layer.cornerRadius = 25
        changeIconFilter(isFiltered: false)
        
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 25
        collectionView.register(UINib(nibName: String(describing: CharacterCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CharacterCollectionCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func changeIconFilter(isFiltered: Bool) {
        filterBtn.backgroundColor = !isFiltered ? UIColor(named: Constants.AssetColors.starColor) : .red
    }
}

extension InitialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getNumberOfCells() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataCell = presenter?.getCellBy(row: indexPath.row),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CharacterCollectionCell.self), for: indexPath) as? CharacterCollectionCell
        else { return UICollectionViewCell() }
        
        cell.updateUI(data: dataCell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CharacterCollectionCell else { return }
        presenter?.didSelectedCell(id: cell.getID())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let leftAndRightPaddings: CGFloat = 16.0
        let numberOfItemsPerRow: CGFloat = 2.0

        let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension InitialViewController: CharacterDetailsDelegate {
    
    func didDismiss() {
        reloadTable()
    }
}

extension InitialViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.filterByText(text: searchText.lowercased())
    }
}

extension InitialViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
       if actualPosition.y > 0 {
           UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
               self.searchBar.isHidden = false
           }) { _ in
               UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
                   self.searchBar.alpha = 1
             })
           }
       } else {
           UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
               self.searchBar.alpha = 0
           }) { _ in
               UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
                   self.searchBar.isHidden = true
             })
           }
       }
   }
}

protocol InitialRouterDelegate: AnyObject {
    func navegateToCharacterDetails(character: Character)
}

extension InitialViewController: InitialRouterDelegate {
    
    func navegateToCharacterDetails(character: Character) {
        if ((self.presentedViewController as? CharacterDetailsViewController) != nil) {
            dismiss(animated: true)
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: Constants.NavigationsName.characterDetails, bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: Constants.NavigationsName.characterDetails) as? CharacterDetailsViewController, let sheet = viewController.sheetPresentationController else { return }

        sheet.detents = [.medium(), .large()]
        
        viewController.dataStore?.character = character
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }
}
