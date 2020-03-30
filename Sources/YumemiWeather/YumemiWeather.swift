import Foundation

struct Request: Decodable {
    let area: String
    let date: Date
}

struct Response: Encodable {
    let weather: String
    let maxTemp: Int
    let minTemp: Int
    let date: Date
}

enum Weather: String, CaseIterable {
    case sunny
    case cloudy
    case rainy
}

final public class YumemiWeather {
    
    public enum Error: Swift.Error {
        case invalidParameterError
        case unknownError
    }
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }()
    
    public static func fetchWeather(_ jsonString: String) throws -> String {
        guard let requestData = jsonString.data(using: .utf8) else {
            throw Error.invalidParameterError
        }
        
        let request = try decoder.decode(Request.self, from: requestData)
        
        let maxTemp = Int.random(in: 10...40)
        let minTemp = Int.random(in: -40..<maxTemp)
        
        let response = Response(
            weather: Weather.allCases.randomElement()!.rawValue,
            maxTemp: maxTemp,
            minTemp: minTemp,
            date: request.date
        )
        
        let responseData = try encoder.encode(response)
        
        if Int.random(in: 0...4) == 4 {
            throw Error.unknownError
        }
        
        return String(data: responseData, encoding: .utf8)!
    }
    
}