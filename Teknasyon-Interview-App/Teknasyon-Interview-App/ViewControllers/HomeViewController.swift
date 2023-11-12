//
//  ViewController.swift
//  Teknasyon-Interview-App
//
//  Created by Ozgun Dogus on 9.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    private var currentPage: Int = 1
      private var totalMovies: Int = 0
      private let moviesPerPage: Int = 10

    private let loadingIndicator: UIActivityIndicatorView = {
           let indicator = UIActivityIndicatorView(style: .medium)
           indicator.translatesAutoresizingMaskIntoConstraints = false
           indicator.hidesWhenStopped = true
           indicator.color = .blue
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
        collectionView.backgroundColor = .red
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)

        // SearchBar'ın constraints'lerini ayarla
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // UITableView'nin constraints'lerini ayarla
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true

        // UICollectionView'nin constraints'lerini ayarla
        collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true


        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")


        // UITableView'nin delegate ve dataSource'ını belirle
        tableView.delegate = self
        tableView.dataSource = self

        // UICollectionView'nin delegate ve dataSource'ını belirle
        collectionView.delegate = self
        collectionView.dataSource = self

        // SearchBar'ın delegate'ini ayarla
        searchBar.delegate = self
        
        loadInitialData()
    }
    
    private func loadInitialData() {
        loadingIndicator.startAnimating()
          
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self = self else { return }

                self.fetchStarMoviesWithPagination(page: self.currentPage)
                self.fetchComedyMoviesWithPagination(page: self.currentPage)
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




extension ViewController: UISearchBarDelegate {
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

        // Klavyeyi kapat
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          // İlgili hücreyi döndür (örneğin, UITableViewCell)
          let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath)
          let movie = movies[indexPath.row]
          cell.textLabel?.text = movie.title

          // Görseli yükle
          APIManager.shared.fetchImage(for: movie.poster) { result in
              switch result {
              case .success(let imageData):
                  // Ana thread üzerinde çalıştır
                  DispatchQueue.main.async {
                      // Görseli hücreye ekle
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

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
   
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let movie = movies[indexPath.item]
        cell.setImage(with: movie.poster)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // CollectionView'da bir hücre görüntülenmeden önce kontrol et
        // Eğer sona gelinmişse ve daha fazla veri varsa, yeni verileri çek
        if indexPath.item == comedyMovies.count - 1 && comedyMovies.count < totalMovies {
                    fetchComedyMoviesWithPagination(page: currentPage)
                }
    }
}

 

