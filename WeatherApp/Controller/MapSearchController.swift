//
//  MapSearchController.swift
//  WeatherApp
//
//  Created by Jakov Juric on 26/01/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import MapKit

class MapSearchController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var weatherModel = GetWeatherDataModel()
    var searchResults = [MKLocalSearchCompletion]()
    var weatherData: List!
    var cityName: String!
    var coordinates: Coordinates!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addPinAfter(gesture:)))
        longPress.minimumPressDuration = 1.50
        mapView.addGestureRecognizer(longPress)

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func showError(message: String) {
        let ac = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    @objc func addPinAfter(gesture: UIGestureRecognizer) {
        guard gesture.state == .began else { return }
        
        mapView.removeAnnotations(mapView.annotations)
        
        let point = gesture.location(in: mapView)
        let pin = MKPointAnnotation()
        pin.coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        pin.title = "Click + for more options"
        
        var region = MKCoordinateRegion()
        region.span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        region.center = pin.coordinate
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(pin)
    }
}

extension MapSearchController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        weatherModel.getWeather(coordinates: mapView.centerCoordinate)
        weatherModel.getForecast(coordinates: mapView.centerCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
        let addButton = UIButton(type: .contactAdd)
        addButton.tag = annotation.hash
        
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = addButton
        
        weatherModel.onGotForecast = { [weak self] in
            guard let image = UIImage(named: (self?.weatherModel.fiveDayForecast[0].weather[0].customIcon?.rawValue)!) else { return }
            self?.weatherData = self?.weatherModel.fiveDayForecast[0]
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: annotationView.frame.width, height: annotationView.frame.height))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            annotationView.leftCalloutAccessoryView = imageView
        }
        weatherModel.onGotData = { [weak self] data in
            self?.cityName = data.name
            self?.coordinates = data.coord
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "DetailedWeather", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailedWeather" {
            guard let controller = segue.destination as? DetailViewController else { return }
            controller.weatherData = weatherData
            controller.city = cityName
            controller.coord = coordinates
        }
        
    }

}

extension MapSearchController: UISearchBarDelegate {
    //START SEARCH
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            
            guard response != nil else { return }
            
            if response?.mapItems[0].placemark.locality?.caseInsensitiveCompare(query) == .orderedSame {
                guard let center = response?.mapItems[0].placemark.coordinate else { return }
                
                var region = MKCoordinateRegion()
                region.span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                region.center = center
                self?.mapView.setRegion(region, animated: true)
                
                let pin = MKPointAnnotation()
                pin.coordinate = center
                pin.title = "Click + to add favorite"
                self?.mapView.addAnnotation(pin)
            } else {
                self?.showError(message: "Invalid city name, please try again")
            }
        }
    }
    //HIDE KEYBOARD ON TOUCH
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

