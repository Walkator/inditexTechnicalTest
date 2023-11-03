//
//  InitialViewControllerTests.swift
//  RickAndMortyApp
//
//  Created by Daniel Aguilar Domínguez on 7/9/23.
//

import Foundation
@testable import RickAndMortyApp
import XCTest

class InitialViewControllerTests: XCTestCase {
    
    var sut: InitialViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    private func setupController() {
        let storyboard = UIStoryboard(name: Constants.NavigationsName.initial, bundle: Bundle.main)
        sut = storyboard.instantiateInitialViewController() as? InitialViewController
        sut.loadView()
    }
    
    func loadView(isNavigation: Bool = false) {
        window.addSubview(sut.view)
        if isNavigation {
            window.rootViewController = UINavigationController(rootViewController: sut)
        }
        RunLoop.current.run(until: Date())
    }
    
    class InitialPresenterSpy: InitialPresenterDelegate {
        
        var setupViewCalled = false
        var modeOnlyScoredCalled = false
        var getNumberOfCellsCalled = false
        var getCellByCalled = false
        var didSelectedCellCalled = false
        var filterByTextCalled = false
        
        func setupView() {
            setupViewCalled = true
        }
        
        func modeOnlyScored() {
            modeOnlyScoredCalled = true
        }
        
        func getNumberOfCells() -> Int {
            getNumberOfCellsCalled = true
            return 1
        }
        
        func getCellBy(row: Int) -> CharacterCollectionCellModel? {
            getCellByCalled = true
            return CharacterCollectionCellModel(id: 0, image: "", name: "test", stars: 0)
        }
        
        func didSelectedCell(id: Int?) {
            didSelectedCellCalled = true
        }
        
        func filterByText(text: String) {
            filterByTextCalled = true
        }
    }
        
    func testFilteredBtn() {
        let spy = InitialPresenterSpy()
        sut.presenter = spy
        
        sut.filteredBtn(UIButton())
        
        XCTAssertTrue(spy.modeOnlyScoredCalled)
    }
    
    func testChangeIconFilter() {
        let spy = InitialPresenterSpy()
        sut.presenter = spy
        
        sut.changeIconFilter(isFiltered: true)
        
        XCTAssertEqual(sut.filterBtn.backgroundColor, UIColor.red)
    }
    
    func testSearchBar() {
        let spy = InitialPresenterSpy()
        sut.presenter = spy
        
        sut.searchBar(UISearchBar(), textDidChange: "test")
        
        XCTAssertTrue(spy.filterByTextCalled)
    }
    
    func testNavegateToCharacterDetails() {
        let spy = InitialPresenterSpy()
        sut.presenter = spy
        
        loadView(isNavigation: true)
        sut.navegateToCharacterDetails(character: Character(id: 2, name: "", status: "", species: "", type: "", gender: "", origin: Origin(name: "", url: ""), location: Location(name: "", url: ""), image: "", episode: [""], url: "", created: ""))
        
        XCTAssertTrue(sut.navigationController?.presentationController != nil)
    }
}
