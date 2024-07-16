//
//  PPAPIResourceList.swift
//  PokePractice
//
//  Created by Carlos Paredes on 15/7/24.
//

import Foundation

struct PPAPIResourceList: Codable {
    let next: String
    let results:[PPNamedAPIResource]
}
