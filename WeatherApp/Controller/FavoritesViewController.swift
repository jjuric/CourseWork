//
//  FavoritesViewController.swift
//  WeatherApp
//
//  Created by Jakov Juric on 03/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import CoreLocation

class FavoritesViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var favoriteCities = [FavoriteCity]()
    var coordinate: Coordinates!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupBackgroundImage(named: "bgclear")
        self.tableView.tableFooterView = UIView()
        self.tableView.alwaysBounceVertical = false
    }
    override func viewWillAppear(_ animated: Bool) {
        if let data = defaults.value(forKey: "Favorites") as? Data {
            if let favoriteCities = try? PropertyListDecoder().decode([FavoriteCity].self, from: data) {
                self.favoriteCities = favoriteCities
            }
        }
        self.navigationController?.navigationBar.topItem?.title = "Favorite cities"
        self.tableView.reloadData()
    }
}

extension FavoritesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCities.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Favorites") as? FavoritesCell else { return UITableViewCell()}
        cell.cityName.text = favoriteCities[indexPath.row].name
        cell.separatorInset = UIEdgeInsets.zero
        cell.backgroundColor = .clear
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinate = favoriteCities[indexPath.row].coordinate
        performSegue(withIdentifier: "FavoriteDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FavoriteDetail" {
            guard let controller = segue.destination as? CurrentWeatherViewController else { return }
            controller.updateLocation = false
            controller.manualCoordinates = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon)
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteCities.remove(at: indexPath.row)
            defaults.set(try? PropertyListEncoder().encode(favoriteCities), forKey: "Favorites")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension FavoritesViewController {
    func setupBackgroundImage(named background: String) {
        let backgroundImage = UIImageView(image: UIImage(named: background))
        backgroundImage.clipsToBounds = true
        backgroundImage.contentMode = .scaleAspectFill
        self.tableView.backgroundView = backgroundImage
    }
    func setupNavigation() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

