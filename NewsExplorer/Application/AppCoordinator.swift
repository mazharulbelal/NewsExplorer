//
//  AppCoordinator.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//
import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigationController = UINavigationController()
        let newsCoordinator = NewsListCoordinator(
            navigationController: navigationController
        )
        newsCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
