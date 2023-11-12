//
//  LoadingIndicator.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 12.11.2023.
//

import UIKit

class LoadingIndicator {

    static let shared = LoadingIndicator()

    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .systemIndigo
        return indicator
    }()

    private init() {
        setupIndicatorView()
    }

    private func setupIndicatorView() {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        keyWindow.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor)
        ])
    }

    func show() {
        indicatorView.startAnimating()
    }

    func hide() {
        indicatorView.stopAnimating()
    }
}

