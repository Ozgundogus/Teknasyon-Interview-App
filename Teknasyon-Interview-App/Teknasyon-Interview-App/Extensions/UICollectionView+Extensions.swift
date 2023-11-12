//
//  UICollectionView+Extensions.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 9.11.2023.
//

import Foundation
import UIKit

extension UICollectionView {
    func addSpacing(_ spacing: CGFloat, for section: Int) {
        let layout = self.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset.top = spacing
    }
}
