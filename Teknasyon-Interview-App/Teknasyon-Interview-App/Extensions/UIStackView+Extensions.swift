//
//  UICollectionView+Extensions.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 9.11.2023.
//


import UIKit

extension UIStackView {
    func addSpacing(_ spacing: CGFloat) {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: spacing).isActive = true
        self.addArrangedSubview(spacer)
    }
}

