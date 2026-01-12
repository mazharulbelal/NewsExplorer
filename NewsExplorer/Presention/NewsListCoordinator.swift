//
//  NewsListCoordinator.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class NewsListCoordinator: Coordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = NewsListViewModel()
        let viewController = NewsListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
