//
//  ViewController.swift
//  hawa
//
//  Created by Felinda Gracia Lubis on 6/21/20.
//  Copyright © 2020 Felinda Lubis. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate{
    
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {        weatherManager.fetchWeather(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {        weatherManager.fetchWeather(searchTextField.text!)
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
    
    func updateWeather(_ manager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.bgImage.image = UIImage(named: weather.conditionName)
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.cityName
            self.descLabel.text = weather.desc
            self.mainLabel.text = weather.main
            self.humidLabel.text = "\(String (weather.humidity))%"
            self.quoteLabel.text = "\"\(weather.hawaQuote)\""
        }
    }
    
    func wasError(_ error: Error){
        print(error)
    }
}

