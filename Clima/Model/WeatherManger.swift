//
//  WeatherManger.swift
//  Clima
//
//  Created by Youssef Eldeeb on 18/09/2021.
//

import Foundation
import CoreLocation

protocol WeatherMangerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error )
}

struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=b9c4c35161c59bb0a91b37d7cdc709f8&units=metric"
    var delegate: WeatherMangerDelegate?
    
    func fetchWeather(cityName: String){
        let weatherURL = "\(url)&q=\(cityName)"
        self.performRequest(urlString: weatherURL)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let weatherURL = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: weatherURL)
    }
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let unwrappedData = data{
                    if let weather = self.parseJSON(weatherData: unwrappedData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
                if let unwrappedError = error {
                    self.delegate?.didFailWithError(error: unwrappedError)
                    return
                }
            }
            task.resume()
        }
    }
    func parseJSON(weatherData: Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherDataAPI.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
   
}
