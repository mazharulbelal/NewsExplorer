//
//  SearchControllerProvider.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import UIKit

final class SearchControllerProvider {

    static let shared = SearchControllerProvider()

    private init() {}

    func makeSearchController(placeholder: String = "Search") -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = placeholder
        controller.automaticallyShowsCancelButton = true
        return controller
    }

    private lazy var sharedController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search"
        controller.automaticallyShowsCancelButton = true
        return controller
    }()

    func sharedSearchController() -> UISearchController {
        sharedController
    }
}

