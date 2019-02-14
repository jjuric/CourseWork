//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Jakov Juric on 29/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var detailSubView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    var weatherData: List!
    var city: String!
    var coord: Coordinates!
    private let defaults = UserDefaults.standard
    private var favCities = [FavoriteCity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToFavorites))
        navigationItem.rightBarButtonItem = addButton
        detailSubView.backgroundColor = .clear
        
        if let _ = weatherData, let _ = city {
            setupDetailScreen()
        }
    }
}
extension DetailViewController {
    func showAlert(message: String) {
        let ac = UIAlertController(title: "Done!", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func addToFavorites() {
        if let favorites = defaults.value(forKey: "Favorites") as? Data {
            guard let favoriteCities = try? PropertyListDecoder().decode([FavoriteCity].self, from: favorites) else { return }
            favCities = favoriteCities
            let newCity = FavoriteCity(name: city, coordinate: coord)
            if favCities.contains(where: { $0.name == newCity.name }) {
                showAlert(message: "You already saved that city to favorites.")
            } else {
                favCities.append(newCity)
                defaults.set(try? PropertyListEncoder().encode(favCities), forKey: "Favorites")
                showAlert(message: "City added to favorites")
            }
        } else {
            favCities.append(FavoriteCity(name: city, coordinate: coord))
            defaults.set(try? PropertyListEncoder().encode(favCities), forKey: "Favorites")
            showAlert(message: "City added to favorites")
        }
    }
    
    func setupBackgroundImage(named background: String) {
        let backgroundImage = UIImageView(frame: self.view.frame)
        backgroundImage.clipsToBounds = true
        backgroundImage.image = UIImage(named: background)
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func setupDetailScreen() {
        guard let image = UIImage(named: (weatherData.weather[0].customIcon?.rawValue)!) else { return }
        guard let background = weatherData.weather[0].customIcon?.background else { return }
        setupBackgroundImage(named: background)
        imageView.image = image
        cityName.text = city
        weatherDescription.text = weatherData.weather[0].main
        currentTime.text = weatherData.dt_hours
        maxTemp.text = ("\(Int(weatherData.main.temp_max - 273))ºC")
        minTemp.text = ("\(Int(weatherData.main.temp_min - 273))ºC")
    }
}

