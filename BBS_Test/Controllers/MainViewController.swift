//
//  MainViewController.swift
//  BBS_Test
//
//  Created by Clément Lavoisier on 03/05/2018.
//  Copyright © 2018 Clément Lavoisier. All rights reserved.
//

import UIKit

// MARK: - Struct
struct FilmsList: Decodable {
    let results: [Film]?
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Var
    private var selectedFilm:Film?
    private var films:[Film]?
    private var sortByHistory:Bool = true

    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortLabel: UILabel!
    
    // MARK: - Common init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        self.loadFilms()
    }

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
    
    // MARK: - API
    private func loadFilms() {
        let url = URL(string: "https://swapi.co/api/films/")
    
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
        
            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                
                let results = try decoder.decode(FilmsList.self, from: data)
                self.films = results.results
                self.sortFilms()
                self.dismissLoading()
                
            } catch let jsonErr {
                print("Error serializing json :", jsonErr)
                self.dismissLoading()
            }
        }.resume()
    }
    
    private func sortFilms() {
    
        // By history
        if self.sortByHistory {
            self.films?.sort(by: { (filmA, filmB) -> Bool in
                guard let idA = filmA.episode_id, let idB = filmB.episode_id else {
                    return false
                }
                return idA < idB
            })
            
        // By release date
        } else {
            self.films?.sort(by: { (filmA, filmB) -> Bool in
                guard let dateA = filmA.release_date, let dateB = filmB.release_date else {
                    return false
                }
                return dateA.compare(dateB) == .orderedAscending
            })
            
        }
        
        DispatchQueue.main.async {
            self.sortLabel.text = (self.sortByHistory) ? "Dans l'ordre de l'histoire" : "Par date de sortie"
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let film:Film = films![indexPath.row]
        
        cell.producerLabel.text = film.director
        cell.coverImage.image = (film.episode_id != nil) ? UIImage(named: "episode_\(film.episode_id!)") : nil
        cell.episodeLabel.text = (film.episode_id != nil) ? "ÉPISODE \(film.episode_id!)" : ""
        cell.titleLabel.text = film.title?.uppercased()
        cell.yearLabel.text = (film.release_date != nil) ? DateFormatter.yyyy.string(from:film.release_date!) : ""

        return cell
    }
    
    // MARK: - Table view delegate & prepareForSegue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFilm = films![indexPath.row]
        self.performSegue(withIdentifier: "showDetailsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSegue" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.film = self.selectedFilm
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func didTapOnFilterView(_ sender: Any) {
        self.sortByHistory = !self.sortByHistory
        self.sortFilms()
    }
}


// MARK: - CustomTableCellViewCell

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
}


