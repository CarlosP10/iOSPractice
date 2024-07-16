//
//  PPokemonListViewViewModel.swift
//  PokePractice
//
//  Created by Carlos Paredes on 15/7/24.
//

import Foundation
import Combine

protocol PPokemonListViewViewModelDelegate: AnyObject {
    func didLoadInitialPokemons()
    func didLoadMorePokemons(with newIndexPath: [IndexPath])
}

class PPokemonListViewViewModel {
    @Published var pokemonsNamedAPIResource: [PPNamedAPIResource] = []
    @Published var pokemonDetails: [String: Pokemon] = [:]
    @Published var isLoadingMore = false
    @Published var isLoadFirstTime = true
    
    let limitPerPage = 20
    var offset = 0
    public weak var delegate: PPokemonListViewViewModelDelegate?
    
    private var client = PHttpClient()
    private var cancellables = Set<AnyCancellable>()
    
    func loadPokemons() {
        print("Loading pokemons...")
        isLoadingMore = true
        let url = URL.allPokemons
        let queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limitPerPage))
        ]
        
        let resource = Resource<PPAPIResourceList>(url: url, method: .get(queryItems))
        let startIndex = pokemonsNamedAPIResource.count
        client.load(resource)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error loading pokemons: \(error)")
                case .finished:
                    print("Finished loading pokemons.")
                    break
                }
            } receiveValue: { [weak self] success in
                guard let self = self else { return }
                self.pokemonsNamedAPIResource.append(contentsOf: success.results)
                self.pokemonsNamedAPIResource.sort { $0.id! < $1.id! }//sort by name
                offset += limitPerPage
                print("First Next page URL:", success.next)
                self.loadPokemonDetails(startIndex: startIndex)
            }
            .store(in: &cancellables)
    }
    
    private func loadPokemon(pokemonString: String) -> AnyPublisher<Pokemon, Error> {
        //print("Loading details for pokemon: \(pokemonString)")
        let resource = Resource<Pokemon>(url: URL.getPokemon(pokemonString))
        return client.load(resource)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] success in
                self?.pokemonDetails[pokemonString]  = success
            })
            .eraseToAnyPublisher()
    }
    
    private func loadPokemonDetails(startIndex: Int = 0) {
        
        let pokemonDataPublishers = pokemonsNamedAPIResource.publisher
            .flatMap { 
                self.loadPokemon(pokemonString: $0.url)}
            .collect()
        
        pokemonDataPublishers
            .collect()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.isLoadingMore = false
                    print("Error loading pokemon details: \(error)")
                case .finished:
                    print("Finished loading all pokemon details.")
                    if self.isLoadFirstTime {
                        self.delegate?.didLoadInitialPokemons()
                    }
                    
                    if !self.isLoadFirstTime {
                        let endIndex = self.pokemonsNamedAPIResource.count
                        let newIndexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                        self.delegate?.didLoadMorePokemons(with: newIndexPaths)
                    }
                    self.isLoadFirstTime = false
                    self.isLoadingMore = false
                    break
                }
            } receiveValue: { _ in
                // Handle successful loading of all Pokémon details if needed
            }
            .store(in: &cancellables)
    }
}
