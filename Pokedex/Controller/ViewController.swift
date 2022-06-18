//
//  ViewController.swift
//  Pokedex
//
//  Created by Miguel Sablan on 6/17/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemonManager = PokeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        pokemonManager.delegate = self
        
        nameLabel.text = ""
    }
}

//MARK: - PokeManagerDelegate
extension ViewController: PokeManagerDelegate {
    func didGetPokemon(_ pokemonManager: PokeManager, pokemon: PokemonModel) {

        let imageURL = pokemon.image
        
        DispatchQueue.main.async {
            self.nameLabel.text = pokemon.name
            self.pokemonImage.load(url: imageURL)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    // When user taps else where
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    // When user tries to deselect textfield, keeps keyboard onscreen
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // triggered when textfield .endEditing()
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let pokemon = searchTextField.text {
            pokemonManager.getPokemon(for: pokemon)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - UIImageView
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
