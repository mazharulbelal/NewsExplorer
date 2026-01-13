//
//  LoaderView.swift
//  NewsExplorer
//
//  Created by Md Mazharul Islam on 12/1/26.
//

import UIKit

final class LoaderView: UIView {

    // MARK: - Singleton
    static let shared = LoaderView()

    // MARK: - UI
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        return view
    }()

    // MARK: - Init
    private override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported. Use LoaderView.shared")
    }

    // MARK: - Setup
    private func configure() {
        isUserInteractionEnabled = true
        isAccessibilityElement = true
        accessibilityLabel = "Loading"

        backgroundColor = .clear
        alpha = 0
        isHidden = true

        addSubview(blurView)
        addSubview(spinner)

        blurView.translatesAutoresizingMaskIntoConstraints = false
        spinner.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),

            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public API (Instance)
    func show() { set(visible: true) }
    func hide() { set(visible: false) }

   
    static func show(on hostView: UIView? = nil) {
        let loader = LoaderView.shared
        let container: UIView

        if let hostView {
            container = hostView
        } else if let windowScene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene }).first,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            container = window
        } else {
            return
        }

        if loader.superview !== container {
            loader.removeFromSuperview()
            loader.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(loader)
            NSLayoutConstraint.activate([
                loader.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                loader.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                loader.topAnchor.constraint(equalTo: container.topAnchor),
                loader.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }

        loader.show()
    }

    static func hide() {
        LoaderView.shared.hide()
    }

    // MARK: - Private
    private func set(visible: Bool) {
        let currentlyVisible = !isHidden && alpha > 0.0
        guard visible != currentlyVisible else { return }

        if visible {
            isHidden = false
            spinner.startAnimating()
        }

        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = visible ? 1 : 0
        }, completion: { _ in
            if !visible {
                self.spinner.stopAnimating()
                self.isHidden = true
            }
        })
    }
}

