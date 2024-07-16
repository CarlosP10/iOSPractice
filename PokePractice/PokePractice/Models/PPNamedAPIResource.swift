//
//  PPNamedAPIResource.swift
//  PokePractice
//
//  Created by Carlos Paredes on 15/7/24.
//

import Foundation

struct PPNamedAPIResource: Codable {
    let name: String
    let url: String
    
    var id: Int? {
        return Int(url.trimmingCharacters(in: CharacterSet(charactersIn: "/")).components(separatedBy: "/").last ?? "")
    }
}
