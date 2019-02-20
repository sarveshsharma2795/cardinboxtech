//
//  Model.swift
//  Cardinbox tech round
//
//  Created by Sarvesh on 20/02/19.
//  Copyright © 2019 Sarvesh. All rights reserved.
//

import Foundation
import Alamofire

struct GlobalConstants{
  static let apiKey = "JQI7PECRYS5U92U9"
  static let STATUS_OK = 200...210
  static let STATUS_NO_INTERNET = 0
  static let STATUS_INTERNAL_SERVER_ERROR = 500...505
  static let STATUS_BAD_REQUEST = 400...410
}

class GetInformation{
    func makeStockRequest(withURL url: URL, _ callback: @escaping (DateInfo?, Int?) -> Void){
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: nil).response{
            (response) in
            do{
                if let responseData = response.data{
                    let feedsModel = try JSONDecoder().decode(DateInfo.self, from: responseData)
                    callback(feedsModel, (response.response?.statusCode)!)
                }
            }
            catch{
                print(error)
                callback(nil, (response.response?.statusCode))
            }
        }
    }
    func makeCurrencyRequest(withURL url: URL, _ callback: @escaping (ExchangeRate?, Int?) -> Void){
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: nil).response{
            (response) in
            do{
                if let responseData = response.data{
                    let feedsModel = try JSONDecoder().decode(ExchangeRate.self, from: responseData)
                    callback(feedsModel, (response.response?.statusCode)!)
                }
            }
            catch{
                print(error)
                callback(nil, (response.response?.statusCode))
            }
        }
    }
}

class ExchangeRate: Decodable{
    let exchangeKey: ExchangeInfo
    private enum CodingKeys: String, CodingKey{
        case exchangeKey = "Realtime Currency Exchange Rate"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        exchangeKey = try values.decodeIfPresent(ExchangeInfo.self, forKey: .exchangeKey)!
    }
}

class ExchangeInfo: Decodable{
    let fromCurrency: String
    let toCurrency: String
    let exchangeRate: String
    private enum CodingKeys: String, CodingKey{
        case fromCurrency = "1. From_Currency Code", toCurrency = "3. To_Currency Code", exchangeRate = "5. Exchange Rate"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fromCurrency = try values.decodeIfPresent(String.self, forKey: .fromCurrency) ?? ""
        toCurrency = try values.decodeIfPresent(String.self, forKey: .toCurrency) ?? ""
        exchangeRate = try values.decodeIfPresent(String.self, forKey: .exchangeRate) ?? ""
    }
}

class DateInfo: Decodable{
    let timeSeries: [String: StockInfo]?
    private enum CodingKeys: String, CodingKey{
        case timeSeries = "Time Series (Daily)"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timeSeries = try values.decodeIfPresent([String: StockInfo].self, forKey: .timeSeries)
    }
}

class StockInfo: Decodable{
    let openPrice: String
    let highPrice: String
    let lowPrice: String
    let closePrice: String
    let volume: String
    private enum CodingKeys: String, CodingKey{
        case openPrice = "1. open", highPrice = "2. high", lowPrice = "3. low", closePrice = "4. close", volume = "6. volume"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        openPrice = try values.decodeIfPresent(String.self, forKey: .openPrice) ?? ""
        highPrice = try values.decodeIfPresent(String.self, forKey: .highPrice) ?? ""
        lowPrice = try values.decodeIfPresent(String.self, forKey: .lowPrice) ?? ""
        closePrice = try values.decodeIfPresent(String.self, forKey: .closePrice) ?? ""
        volume = try values.decodeIfPresent(String.self, forKey: .volume) ?? ""
    }
}
