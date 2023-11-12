//
//  HomeViewController.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 9.11.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    private var currentPage: Int = 1
    private var totalMovies: Int = 0
    private let moviesPerPage: Int = 10
    
    
 
    private var movies: [Movie] = [] {
        didSet {
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
   
    private var comedyMovies: [Movie] = [] {
            didSet {
                collectionView.reloadData()
            }
        }
    
    private let loadingIndicator: UIActivityIndicatorView = {
           let indicator = UIActivityIndicatorView(style: .medium)
           indicator.translatesAutoresizingMaskIntoConstraints = false
           indicator.hidesWhenStopped = true
           indicator.color = .systemRed.withAlphaComponent(0.4)
           return indicator
       }()


    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Movies"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
 
        return tableView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemRed.withAlphaComponent(0.4)
        return collectionView
    }()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed.withAlphaComponent(0.4)
        
      
        configureUI()
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")

        tableView.delegate = self
        tableView.dataSource = self

        collectionView.delegate = self
        collectionView.dataSource = self
    
        searchBar.delegate = self
        
        loadInitialData()
    }
    
    
    private func configureUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(collectionView)
       
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

     
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true

   
        collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
       
    }
    
    private func loadInitialData() {
        LoadingIndicator.shared.show()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }

            self.fetchStarMoviesWithPagination(page: self.currentPage)
            self.fetchComedyMoviesWithPagination(page: self.currentPage)
            LoadingIndicator.shared.hide()
        }
    }


    private func fetchStarMoviesWithPagination(page: Int) {
        
           movies.removeAll()

           APIManager.shared.fetchMovies(page: page, filter: "Star") { [weak self] result in
               guard let self = self else { return }
               
               self.loadingIndicator.stopAnimating()
               switch result {
               case .success(let fetchedMovies):
                   self.movies += fetchedMovies
                   self.currentPage += 1
                   self.totalMovies = fetchedMovies.count
               case .failure(let error):
                   print("Data loading error for star movies: \(error.localizedDescription)")
               }
           }
       }

       private func fetchComedyMoviesWithPagination(page: Int) {
    
           comedyMovies.removeAll()

           APIManager.shared.fetchMovies(page: page, filter: "Comedy") { [weak self] result in
               guard let self = self else { return }
              
               self.loadingIndicator.stopAnimating()
               switch result {
               case .success(let fetchedMovies):
                   self.comedyMovies += fetchedMovies
                   self.currentPage += 1
                   self.totalMovies = fetchedMovies.count
               case .failure(let error):
                   print("Data loading error for comedy movies: \(error.localizedDescription)")
               }
           }
       }
}




extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
          
            APIManager.shared.performSearch(with: searchTerm) { result in
                switch result {
                case .success(let movies):
                    self.movies = movies
                case .failure(let error):
                    print("Hata: \(error.localizedDescription)")
                }
            
            }
           
        }

       
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)
          let movie = movies[indexPath.row]
          cell.textLabel?.text = movie.title

    
          APIManager.shared.fetchImage(for: movie.poster) { result in
              switch result {
              case .success(let imageData):
                 
                  DispatchQueue.main.async {
                    
                      cell.imageView?.image = UIImage(data: imageData)
                      cell.setNeedsLayout()
                  }
              case .failure(let error):
                  print("Görsel yükleme hatası: \(error.localizedDescription)")
              }
          }

          return cell
      }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navigationController = navigationController {
            let detailViewController = DetailViewController()
            detailViewController.movie = movies[indexPath.row]
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comedyMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let movie = comedyMovies[indexPath.item]
        cell.setImage(with: movie.poster)
        return cell
    }
}


extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let navigationController = navigationController {
            let detailViewController = DetailViewController()
            detailViewController.movie = comedyMovies[indexPath.item]
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }


    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == comedyMovies.count - 1 && comedyMovies.count < totalMovies {
            fetchComedyMoviesWithPagination(page: currentPage)
        }
    }
}





