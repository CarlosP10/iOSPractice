//
//  Pokemon.swift
//  PokePractice
//
//  Created by Carlos Paredes on 15/7/24.
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let name: String
    let base_experience: Int
    let sprites: PItemSprites
}
