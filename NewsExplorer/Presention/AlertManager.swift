//
//  AlertManager.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import UIKit

import SwiftUI

final class AlertManager {
    static let shared = AlertManager()
    private init() {}

    private var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first
    }

    func showAlert(title: String, message: String) {
        presentAlert(title: title, message: message, actions: [
            UIAlertAction(title: "OK", style: .default)
        ])
    }

    func showAlertWithAction(
        title: String,
        message: String,
        submitTitle: String = "Okay",
        submitAction: @escaping () -> Void = {}
    ) {
        presentAlert(title: title, message: message, actions: [
            UIAlertAction(title: submitTitle, style: .default) { _ in submitAction() }
        ])
    }

    private func presentAlert(title: String, message: String, actions: [UIAlertAction]) {
        DispatchQueue.main.async {
            guard let topController = self.topMostViewController() else { return }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            actions.forEach { alertController.addAction($0) }
            topController.present(alertController, animated: true)
        }
    }

    private func topMostViewController() -> UIViewController? {
        var top = window?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
}
