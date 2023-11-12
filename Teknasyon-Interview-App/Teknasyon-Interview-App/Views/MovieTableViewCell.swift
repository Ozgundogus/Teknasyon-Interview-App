//
//  TableViewCell.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 10.11.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .red
        return view
    }()

    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0 // Birden fazla satıra izin ver
        return label
    }()

    var movie: Movie? {
        didSet {
            if let movie = movie {
                setTitle(movie.title)
                setImage(with: movie.poster)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(containerView)
        containerView.addSubview(customImageView)
        containerView.addSubview(titleLabel)

        // ContainerView'ın constraints'lerini ayarla
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true

        // ImageView'ın constraints'lerini ayarla
        customImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        customImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        customImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        customImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true
        // TitleLabel'ın constraints'lerini ayarla
        titleLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func setImage(with urlString: String) {
        APIManager.shared.fetchImage(for: urlString) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.customImageView.image = image
                    }
                }
            case .failure(let error):
                print("Image loading error: \(error.localizedDescription)")
            }
        }
    }
}

