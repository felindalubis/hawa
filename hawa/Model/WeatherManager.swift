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
    func updateQuote(_ manager: WeatherManager, _ quote: QuoteModel)
    func wasError(_ error: Error)
}

struct WeatherManager {
    var weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=6e28950b9903e007a226596462252727"
    var quoteUrl = "https://thesimpsonsquoteapi.glitch.me/quotes"
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(_ cityName : String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print("url: \(urlString)")
        performRequest(urlString: urlString, urlString2: quoteUrl)
    }
    
    func fetchWeather(_ lat : Double, _ lon: Double) {
        let urlString = "\(weatherUrl)&lat=\(lat)&lon=\(lon)"
        print("url: \(urlString)")
        performRequest(urlString: urlString, urlString2: quoteUrl)
    }
    
    func performRequest(urlString : String, urlString2 : String){
        // Create a URL
        if let url1 = URL(string: urlString), let url2 = URL(string: urlString2) {
            
            // Create a URLSession
            let session = URLSession(configuration: .default)
            
            //Give session a task
            let task1 = session.dataTask(with: url1) { (data, response, error) in
                if error != nil {
                    self.delegate?.wasError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.updateWeather(self, weather)
                    }
                }
            }
            let task2 = session.dataTask(with: url2) { (data, response, error) in
                if error != nil {
                    self.delegate?.wasError(error!)
                    return
                }
                if let safeData = data {
                    if let quote = self.parseJSON(quoteData: safeData) {
                        self.delegate?.updateQuote(self, quote)
                    }
                }
            }
            //Start the task
            task1.resume()
            task2.resume()
        }
    }
    
    func parseJSON(quoteData: Data) -> QuoteModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([QuoteData].self, from: quoteData)
            print(decodedData)
            let quoteModel = QuoteModel(result: decodedData)
            return quoteModel
        } catch {
            self.delegate?.wasError(error)
            return nil
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
