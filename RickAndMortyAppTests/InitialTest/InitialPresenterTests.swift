//
//  InitialPresenter.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 7/9/23.
//

import Foundation
@testable import RickAndMortyApp
import XCTest

class InitialPresenterTests: XCTestCase {
    
    var sut: InitialPresenter!
    
    override func setUp() {
        super.setUp()
        setupPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupPresenter() {
        sut = InitialPresenter()
    }
    
    class InitialViewControllerSpy: InitialViewDelegate, InitialRouterDelegate {
        
        var setupViewCalled = false
        var reloadTableCalled = false
        var changeIconFilterCalled = false
        var navegateToCharacterDetailsCalled = false
        
        func setupView() {
            setupViewCalled = true
        }
        
        func reloadTable() {
            reloadTableCalled = true
        }
        
        func changeIconFilter(isFiltered: Bool) {
            changeIconFilterCalled = true
        }
        
        func navegateToCharacterDetails(character: Character) {
            navegateToCharacterDetailsCalled = true
        }
    }
    
    class RickAndMortyRepositorySpy: RickAndMortyAPIRepository {
        
        override func getCharacters(completion: @escaping (Result<Characters, FactorError>) -> ()) {
            let data = Characters(info: Info(), results: [Character(id: 0, name: "test", status: "", species: "", type: "", gender: "", origin: Origin(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: "")])
            completion(.success(data))
        }
    }
        
    func testSetup() {
        let spy = InitialViewControllerSpy()
        sut.view = spy
        
        sut.setupView()
        
        XCTAssertTrue(spy.setupViewCalled)
    }
    
    func testSetupWithService() {
        let spy = InitialViewControllerSpy()
        sut.view = spy
        sut.respository = RickAndMortyRepositorySpy()
        
        sut.setupView()
        
        XCTAssertTrue(spy.reloadTableCalled)
    }
    
    func testSetupWithServiceAndDidSelectedCell() {
        let spy = InitialViewControllerSpy()
        sut.view = spy
        sut.respository = RickAndMortyRepositorySpy()
        
        sut.setupView()
        sut.didSelectedCell(id: 0)
        
        XCTAssertTrue(spy.navegateToCharacterDetailsCalled)
    }
 
    func testModeOnlyScored() {
        let spy = InitialViewControllerSpy()
        sut.view = spy
        
        sut.modeOnlyScored()
        
        XCTAssertTrue(spy.reloadTableCalled)
        XCTAssertTrue(spy.changeIconFilterCalled)
    }
    
    func testFilterByText() {
        let spy = InitialViewControllerSpy()
        sut.view = spy
        sut.respository = RickAndMortyRepositorySpy()
        
        sut.setupView()
        sut.filterByText(text: "test")
        
        XCTAssertTrue(spy.reloadTableCalled)
    }
}
