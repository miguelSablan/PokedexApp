//
//  Pokemon.swift
//  Pokedex
//
//  Created by Miguel Sablan on 6/18/22.
//

import Foundation

struct PokemonData: Codable {
    let name: String
    let height: Int
    let weight: Int
    
    let sprites: Sprite
    
}

struct Sprite: Codable {
    let front_default: URL
}
