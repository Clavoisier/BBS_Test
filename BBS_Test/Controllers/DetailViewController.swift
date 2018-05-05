//
//  DetailViewController.swift
//  BBS_Test
//
//  Created by Clément Lavoisier on 03/05/2018.
//  Copyright © 2018 Clément Lavoisier. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Var
    public var film:Film?
    private var characters:[Character] = [Character]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var titreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var charactersLabel: UILabel!
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    
    // MARK: - Common init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateFields()
        self.showLoading()
        self.loadCharacters()
    }
    
    // Hide homebar button
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    // Change status bar text color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Loading methods
    private func showLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func dismissLoading() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - private methods
    private func updateFields() {
        guard let film = self.film else {
            return
        }
        
        self.titreLabel.text = film.title?.uppercased()
        self.productionLabel.text = film.producer
        self.producerLabel.text = (film.director != nil) ? "Réalisé par \(film.director!)" : ""
        self.coverImage.image = (film.episode_id != nil) ? UIImage(named: "episode_\(film.episode_id!)") : nil
        self.episodeLabel.text = (film.episode_id != nil) ? "ÉPISODE \(film.episode_id!)" : ""
        self.dateLabel.text = (film.release_date != nil) ? "SORTI LE \(DateFormatter.ddMMMyyyy.string(from:film.release_date!))".uppercased() : ""
        self.synopsisLabel.text = film.opening_crawl

        var names = ""
        for character in characters {
            if names.count > 0 {
                names += ", "
            }
            names += character.name ?? ""
        }
        self.charactersLabel.text = names;
    }
    
    private func loadCharacters() {
        let count = film?.characters?.count
        var progress = 0
        
        for stringUrl in film?.characters ?? [] {
            
            let url = URL(string: stringUrl)
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                progress += 1
                
                guard let data = data else {
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                    
                    let character = try decoder.decode(Character.self, from: data)
                    
                    self.characters.append(character)
                    
                } catch let jsonErr {
                    print("Error serializing json :", jsonErr)
                }
                
                if (progress == count) {
                    DispatchQueue.main.async {
                        self.updateFields()
                        self.dismissLoading()
                    }
                }
            }.resume()
        }
    }
    
    // MARK: - IBAction
    @IBAction func tapOnBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}
