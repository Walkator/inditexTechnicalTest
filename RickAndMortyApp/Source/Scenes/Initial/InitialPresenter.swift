//
//  InitialPresenter.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 5/9/23.
//

import Foundation

protocol InitialViewDelegate: AnyObject {
    func setupView()
    func reloadTable()
    func changeIconFilter(isFiltered: Bool)
}

class InitialPresenter: InitialPresenterDelegate {
    weak var view: (InitialViewDelegate & InitialRouterDelegate)?
    
    var respository: RickAndMortyRepository = RickAndMortyAPIRepository()
    private var characters: [Character?] = []
    private var filteredCells: [Character?] = []
    private var isFilered: Bool = false
    private var lastSearch: String = ""
    
    func setupView() {
        view?.setupView()
        getData()
    }
    
    private func getData() {
        respository.getCharacters(completion: { [weak self] result in
            if case let .success(data) = result {
                self?.characters = data.results
                self?.filteredCells = data.results
                self?.view?.reloadTable()
            }
        })
    }
    
    func modeOnlyScored() {
        isFilered = !isFilered
        view?.changeIconFilter(isFiltered: isFilered)

        filterByText(text: lastSearch)
    }
    
    func filterByText(text: String) {
        filteredCells.removeAll()
        lastSearch = text
        
        guard !text.isEmpty else {
            filteredCells = characters
            filterByStart()
            return
        }
        
        characters.forEach({
            if $0?.name?.lowercased().contains(text) == true {
                filteredCells.append($0)
            }
        })
        
        if isFilered {
            filterByStart()
        } else {
            view?.reloadTable()
        }
    }
    
    private func filterByStart() {
        guard isFilered else {
            view?.reloadTable()
            return
        }
        
        for character in filteredCells {
            if ManagerStarsReviews.shared.getRatingsBy(id: character?.id) <= 0, let indexToRemove = filteredCells.firstIndex(where: { $0?.id == character?.id }) {
                filteredCells.remove(at: indexToRemove)
            }
        }
        
        view?.reloadTable()
    }
    
    // MARK: Collection Methods
    
    func getNumberOfCells() -> Int {
        return filteredCells.count
    }
    
    func getCellBy(row: Int) -> CharacterCollectionCellModel? {
        guard let character = filteredCells[row], let characterImage = character.image,
              let characterName = character.name, let id = character.id else { return nil }        
        return CharacterCollectionCellModel(id: id, image: characterImage, name: characterName, stars: ManagerStarsReviews.shared.getRatingsBy(id: id))
    }
    
    func didSelectedCell(id: Int?) {
        guard let id = id, let character = characters.filter({ $0?.id == id }).first, let character = character else { return }
        view?.navegateToCharacterDetails(character: character)
    }
}

