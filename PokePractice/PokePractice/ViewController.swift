//
//  ViewController.swift
//  PokePractice
//
//  Created by Carlos Paredes on 15/7/24.
//

import UIKit
import Combine

class ViewController: UITableViewController {
    
    //MARK: UI
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var viewModel = PPokemonListViewViewModel()
    private var cancellables = Set<AnyCancellable>() // Property to store cancellables
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPokemons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .red
        
        viewModel.delegate = self
        
        viewModel.$pokemonDetails
            .receive(on: DispatchQueue.main)
            //.last()
            .sink {[weak self] val in
                //self?.updateTableView()
                //self?.tableView.reloadData()
                //print(String(describing: val))
            }
            .store(in: &cancellables)
        setUpView()
    }
    
    private func setUpView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "pokecell")
        tableView.register(SpinnerTableViewCell.self, forCellReuseIdentifier: "spinnerCell")
        //tableView.separatorStyle = .singleLine
        //tableView.isScrollEnabled = false
        tableView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
        
        spinner.startAnimating()
    }
    
    private func updateTableView() {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonsNamedAPIResource.count //+ (viewModel.isLoadingMore && !viewModel.isLoadFirstTime ? 1 : 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if !viewModel.isLoadFirstTime && indexPath.row == viewModel.pokemonDetails.count && viewModel.isLoadingMore {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "spinnerCell", for: indexPath) as! SpinnerTableViewCell
//            cell.spinner.startAnimating()
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokecell", for: indexPath)
        cell.selectionStyle = .none
        
        let pokemons = viewModel.pokemonsNamedAPIResource[indexPath.row]
        
        var configuration = cell.defaultContentConfiguration()
        
        if let pokemonDetails = viewModel.pokemonDetails[pokemons.url] {
            configuration.text = pokemonDetails.name.capitalized
            configuration.secondaryText = "Base Experience: \(pokemonDetails.base_experience)"
            
            if let frontUrl = pokemonDetails.sprites.front_default,
               let url = URL(string: frontUrl) {
                cell.imageView?.loadImage(from: url.absoluteString){ image in
                    if let image = image {
                        DispatchQueue.main.async {
                            configuration.image = image
                            configuration.imageProperties.maximumSize = CGSize(width: 75, height: 75)
                            cell.contentConfiguration = configuration
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard !viewModel.isLoadFirstTime,
                  !viewModel.pokemonDetails.isEmpty,
                  !viewModel.isLoadingMore else { return }
            viewModel.isLoadingMore = true
            spinner.startAnimating()
            viewModel.loadPokemons()
        }
    }
    
}

extension ViewController: PPokemonListViewViewModelDelegate {
    func didLoadInitialPokemons() {
        spinner.stopAnimating()
        tableView.reloadData()
        //print(String(describing: viewModel.pokemonDetails))
    }
    
    func didLoadMorePokemons(with newIndexPath: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: newIndexPath, with: .automatic)
        }
        updateTableView()
        //tableView.reloadData()
        spinner.stopAnimating()
    }
}
