//
//  PokeManager.swift
//  Pokedex
//
//  Created by Miguel Sablan on 6/18/22.
//

import Foundation

protocol PokeManagerDelegate {
    func didGetPokemon(_ pokemonManager: PokeManager, pokemon: PokemonModel)
    
    func didFailWithError(error: Error)
}

struct PokeManager {
    let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    
    var delegate: PokeManagerDelegate?
    
    func getPokemon(for pokemon: String) {
        let urlString = "\(baseURL)\(pokemon)".lowercased()
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let pokemon = self.parseJSON(safeData) {
                        self.delegate?.didGetPokemon(self, pokemon: pokemon)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ pokemonData: Data) -> PokemonModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
           
            print(decodedData.height)
            print(decodedData.weight)

            let pokemonName = decodedData.name.capitalized
            let pokemonImage = decodedData.sprites.front_default

            let pokemon = PokemonModel(name: pokemonName, image: pokemonImage)
            
            return pokemon
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
