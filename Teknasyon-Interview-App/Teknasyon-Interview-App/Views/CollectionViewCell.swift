//
//  CollectionViewCell.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 10.11.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)

        // ContainerView'ın constraints'lerini ayarla
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true

        // UIImageView'ın constraints'lerini ayarla
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(with urlString: String) {
        // APIManager'dan resmi al ve imageView'e set et
        APIManager.shared.fetchImage(for: urlString) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            case .failure(let error):
                print("Image loading error: \(error.localizedDescription)")
            }
        }
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // Hücre boyutunu ayarla
//        let width = collectionView.bounds.width - 16 // Örneğin, hücreler arasındaki boşluğu çıkartıyoruz
//        let height = collectionView.bounds.height - 16
//        return CGSize(width: width, height: height)
        return CGSize(width: 150, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // Hücreler arasındaki minimum boşluğu ayarla
        return 2
    }
}
