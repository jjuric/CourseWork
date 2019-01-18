//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jakov Juric on 06/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    var weatherModel: GetWeatherDataModel!
    var currentLocation: CurrentLocationModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.tableFooterView = UIView() //Removes empty cells
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        weatherModel = GetWeatherDataModel()
        currentLocation = CurrentLocationModel()

        currentLocation.onGotLocation = { [weak self] coordinates in
            self?.weatherModel.getWeather(coordinates: coordinates)
            self?.weatherModel.getForecast(coordinate: coordinates)
        }
        weatherModel.onGotData = { [weak self] data in
            if let image = data.weather[0].imageData {
                self?.imageView.image = UIImage(data: image)
            }
            self?.descriptionLabel.text = data.weather[0].main
            self?.detailDescriptionLabel.text = "\(Int(data.main.temp_min - 273))ºC / \(Int(data.main.temp_max - 273))ºC"
            self?.cityLabel.text = "\(data.name), \(Int(data.main.temp - 273))ºC"
        }
        weatherModel.onGotForecast = { [weak self] in
            self?.forecastTableView.reloadData()
        }
    }
}
extension CurrentWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel.fiveDayForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ForecastTableViewCell
        cell.separatorInset = UIEdgeInsets.zero // Remove whitespace before cell separator line
        if let image = weatherModel.fiveDayForecast[indexPath.row].weather[0].imageData {
            cell.imagePreview.image = UIImage(data: image)
        }
        cell.dateLabel.text = weatherModel.fiveDayForecast[indexPath.row].dt_hours
        cell.weatherLabel.text = "\(Int(weatherModel.fiveDayForecast[indexPath.row].main.temp - 273))ºC, \(weatherModel.fiveDayForecast[indexPath.row].weather[0].main)"
        return cell
    }
    
}

