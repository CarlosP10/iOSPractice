//
//  URL+Extensions.swift
//  PokePractice
//
//  Created by Carlos Paredes on 15/7/24.
//

import Foundation

extension URL {
    
    static var development: URL {
        URL(string: "https://pokeapi.co")!
    }
    // "/api/v2/"
    
    static var allPokemons: URL {
        URL(string: "/api/v2/pokemon", relativeTo: Self.development)!
    }
    
    static func getPokemon(_ pokemonString: String) -> URL {
        return URL(string: pokemonString)!
    }
}
