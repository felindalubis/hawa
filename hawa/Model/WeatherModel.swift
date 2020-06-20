
import Foundation

struct WeatherModel {
    let id : Int
    let cityName : String
    let temperature : Double
    let main : String
    let humidity : Int
    let desc : String
    
    //computed property
    var tempString : String {
       return String(format: "%.1f", temperature)
    }
    
    var conditionName : String {
        switch id {
        case 200...321:
            return "bg rain"
        case 500...531:
            return "bg rain"
        case 600...622:
            return "bg snow"
        case 700...804:
            return "bg"
        default:
            return"sun.min"
        }
    }
    
    var hawaQuote : String {
        switch id {
        case 200...321:
            return "Let's go to bed, grab the blanket & watch netflix!"
        case 500...531:
            return "Indomie kuah would be great!"
        case 600...622:
            return "Don't forget to turn on the warmer & grab the blanket"
        case 700...804:
            return "It's a good day to just relax or do some activity!"
        default:
            return "It's a good day to just relax or do some activity!"
        }
    }
}
