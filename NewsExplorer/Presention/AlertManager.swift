//
//  AlertManager.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import UIKit

enum AlertManager {

    static func presentError(on presenter: UIViewController,
                             title: String = "Something went wrong",
                             message: String,
                             retryTitle: String = "Retry",
                             cancelTitle: String = "Cancel",
                             onRetry: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let onRetry = onRetry {
            alert.addAction(UIAlertAction(title: retryTitle, style: .default) { _ in onRetry() })
        }

        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))

        // Ensure presented on the main queue
        DispatchQueue.main.async {
            // Avoid presenting multiple alerts if one is already shown
            if presenter.presentedViewController == nil {
                presenter.present(alert, animated: true)
            } else if let nav = presenter.presentedViewController as? UINavigationController,
                      nav.presentedViewController == nil {
                nav.present(alert, animated: true)
            }
        }
    }
}

