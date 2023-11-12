//
//  DetailViewController.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 9.11.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: Movie?
    private let loadingIndicator = LoadingIndicator.shared
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, yearLabel, imdbIDLabel, typeLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imdbIDLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed.withAlphaComponent(0.4)
        
        guard let movie = movie else { return }
        configureNavigationBackButton ()
        startIndicator()
     
        configureUI()
        loadData()
    }
    
   
    private func configureNavigationBackButton (){
        navigationController?.navigationBar.tintColor = .systemGray5

    }
    
 
    
    
    private func configureUI(){
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addSpacing(20)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(imdbIDLabel)
        stackView.addArrangedSubview(typeLabel)
        
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        imageView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        titleLabel.text = movie?.title
        yearLabel.text = "Year: \(movie?.year ?? "")"
        imdbIDLabel.text = "IMDB ID: \(movie?.imdbID ?? "")"
        typeLabel.text = "Type: \(movie?.type ?? "")"
        
        loadImage()
    }
    
    
    private func configureLabels() {
           
            view.addSubview(stackView)

            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

            titleLabel.text = movie?.title
            yearLabel.text = "Year: \(movie?.year ?? "")"
            imdbIDLabel.text = "IMDB ID: \(movie?.imdbID ?? "")"
            typeLabel.text = "Type: \(movie?.type ?? "")"
        }

    private func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        view.addSubview(imageView)

    
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
   
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true

        loadImage()
    }
    private func startIndicator (){
        loadingIndicator.show()
    }
    
    private func loadData() {
           
           DispatchQueue.global().async {
               usleep(700000)
               DispatchQueue.main.async {
                
                   self.loadingIndicator.hide()
               }
           }
       }

    private func loadImage() {
        guard let movie = movie else { return }
        loadingIndicator.show()
        
        if let cachedImage = ImageCache.shared.image(forKey: movie.poster) {
            imageView.image = cachedImage
        } else {
            APIManager.shared.fetchImage(for: movie.poster) { result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                                             ImageCache.shared.setImage(image, forKey: movie.poster)
                                             self.imageView.image = image
                                         }
                    }
                case .failure(let error):
                    print("Image loading error: \(error.localizedDescription)")
                }
            }
        }
    }
}


