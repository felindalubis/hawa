//
//  WeatherManager.swift
//  hawa
//
//  Created by Felinda Gracia Lubis on 6/21/20.
//  Copyright © 2020 Felinda Lubis. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func updateWeather(_ manager: WeatherManager, _ weather: WeatherModel)
    func wasError(_ error: Error)
}

struct WeatherManager {
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=9620dcab9e48cb889bc7c88236a86f19"
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(_ cityName : String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print("url: \(urlString)")
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(_ lat : Double, _ lon: Double) {
        let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
        print("url: \(urlString)")
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString : String){
        // Create a URL
        if let url = URL(string: urlString) {
            
            // Create a URLSession
            let session = URLSession(configuration: .default)
            
            //Give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.wasError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.updateWeather(self, weather)
                    }
                }}
            //Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let cityName = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let main = decodedData.weather[0].main
            let humidity = decodedData.main.humidity
            let desc = decodedData.weather[0].description
            let weatherModel = WeatherModel(id: id, cityName: cityName, temperature: temp, main: main, humidity: humidity, desc: desc)
            return weatherModel
        } catch {
            self.delegate?.wasError(error)
            return nil
        }
    }
}
