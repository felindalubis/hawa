//
//  ViewController.swift
//  hawa
//
//  Created by Felinda Gracia Lubis on 6/21/20.
//  Copyright © 2020 Felinda Lubis. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var charLabel: UILabel!
    @IBOutlet weak var quoteImage: UIImageView!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UIFieldDelegate

extension WeatherViewController : UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        if searchTextField.text != "" {
            weatherManager.fetchWeather(searchTextField.text!)
//            weatherManager.fetchQuote()
            searchTextField.endEditing(true)
        } else {
            searchTextField.placeholder = "Please input city"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {        weatherManager.fetchWeather(searchTextField.text!)
//        weatherManager.fetchQuote()
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Please input city"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate {
    
    func updateWeather(_ manager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.bgImage.image = UIImage(named: weather.conditionName)
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
            self.descLabel.text = weather.desc
            self.mainLabel.text = weather.main
            self.humidLabel.text = "\(String (weather.humidity))%"
        }
    }
    
    func updateQuote(_ manager: WeatherManager, _ quote: QuoteModel) {
        DispatchQueue.main.async {
            self.quoteLabel.text = quote.result[0].quote
            self.charLabel.text = quote.result[0].character
            do {
                let url = URL(string: quote.result[0].image)
                if let stringUrl = url {
                    let data = try Data(contentsOf: stringUrl)
                    self.quoteImage.image = UIImage(data: data)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func wasError(_ error: Error){
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat, lon)
//            weatherManager.fetchQuote()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}
