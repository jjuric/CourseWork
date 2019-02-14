//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jakov Juric on 06/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherModel: GetWeatherDataModel!
    var currentLocation: CurrentLocationModel!
    var background: WeatherIcons!
    
    var updateLocation = true
    var manualCoordinates: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupTable()
        imageView.image = UIImage(named: "weather")
        upperView.backgroundColor = UIColor.clear
        
        weatherModel = GetWeatherDataModel()
        currentLocation = CurrentLocationModel()
        setupLocation()
        handleWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
}
extension CurrentWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.fiveDayForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ForecastCell else { return UITableViewCell() }
        cell.separatorInset = UIEdgeInsets.zero // Remove whitespace before cell separator line
        cell.backgroundColor = UIColor(white: 1, alpha: 0.3)
        if let image = weatherModel.fiveDayForecast[indexPath.row].weather[0].customIcon {
            cell.imagePreview.image = UIImage(named: image.rawValue)
        }
        cell.dateLabel.text = weatherModel.fiveDayForecast[indexPath.row].dt_hours
        cell.dateLabel.textColor = UIColor.black
        cell.weatherLabel.text = "\(Int(weatherModel.fiveDayForecast[indexPath.row].main.temp - 273))ºC, \(weatherModel.fiveDayForecast[indexPath.row].weather[0].main)"
        cell.weatherLabel.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.00
    }
}

extension CurrentWeatherViewController {
    func showError(_ message: String) {
        let ac = UIAlertController(title: "There was an error", message: message, preferredStyle: .alert)
        ac.addAction((UIAlertAction(title: "OK", style: .default, handler: nil)))
        present(ac, animated: false)
    }
    
    func setupTabBar() {
        guard let tabItem = self.tabBarController?.tabBar.items else { return }
        self.tabBarController?.tabBar.barTintColor = UIColor.clear
        self.tabBarController?.tabBar.tintColor = UIColor.orange
        self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.black
        self.tabBarController?.tabBar.backgroundColor = UIColor(white: 1, alpha: 0.1)
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        tabItem[0].image = UIImage(named: "sun")
        tabItem[1].image = UIImage(named: "search")
        tabItem[2].image = UIImage(named: "heart")
        tabItem[0].title = "Current weather"
        tabItem[1].title = "Search location"
        tabItem[2].title = "Favorites"
    }
    
    func setupBackgroundImage(named background: String) {
        let backgroundImage = UIImageView(frame: self.view.frame)
        backgroundImage.clipsToBounds = true
        backgroundImage.image = UIImage(named: background)
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Back"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func setupTable() {
        forecastTableView.allowsSelection = false
        forecastTableView.alwaysBounceVertical = false
        forecastTableView.backgroundColor = UIColor.clear
        forecastTableView.separatorColor = UIColor.orange
        forecastTableView.tableFooterView = UIView() //Removes empty cells
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
    }
    
    func setupLocation() {
        if updateLocation {
            currentLocation.onGotLocation = { [weak self] coordinates in
                self?.weatherModel.getWeather(coordinates: coordinates)
            }
        } else {
            weatherModel.getWeather(coordinates: manualCoordinates)
        }
    }
    
    func handleWeatherData() {
        weatherModel.onGotData = { [weak self] data in
            if let image = data.weather[0].customIcon {
                self?.imageView.image = UIImage(named: image.rawValue)
                self?.setupBackgroundImage(named: image.background)
            }
            self?.descriptionLabel.text = data.weather[0].main
            self?.descriptionLabel.textColor = UIColor.black
            self?.detailDescriptionLabel.text = "\(Int(data.main.temp_min - 273))ºC / \(Int(data.main.temp_max - 273))ºC"
            self?.detailDescriptionLabel.textColor = UIColor.black
            self?.cityLabel.text = "\(data.name), \(Int(data.main.temp - 273))ºC"
            self?.cityLabel.textColor = UIColor.black
        }
        weatherModel.onGotForecast = { [weak self] in
            self?.forecastTableView.reloadData()
        }
        weatherModel.onGotError = { [weak self] errorMsg in
            self?.showError(errorMsg)
        }
    }
}

