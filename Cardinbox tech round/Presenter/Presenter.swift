//
//  Presenter.swift
//  Cardinbox tech round
//
//  Created by Sarvesh on 20/02/19.
//  Copyright © 2019 Sarvesh. All rights reserved.
//

import Foundation

protocol StocksProtocol: NSObjectProtocol {
    func initializeElements()
}

protocol StockDetailsProtocol: NSObjectProtocol {
    func initializeElements(withInfo info: DateInfo)
    func navigateBack()
}

protocol CurrencyProtocol: NSObjectProtocol {
    func initializeUI(withInfo info: ExchangeRate)
    func addSwipe()
}

class StocksPresenter{
    fileprivate let model : GetInformation?
    weak private var view: StocksProtocol?
    
    init(info: GetInformation) {
        self.model = info
    }
    
    func attachView(_ view: StocksProtocol){
        self.view = view
    }
    
    func initializeElements(){
        self.view?.initializeElements()
    }
    
}

class StockDetailsaPresenter{
    fileprivate let model: GetInformation?
    weak private var view: StockDetailsProtocol?
    
    init(info: GetInformation){
        self.model = info
    }
    
    func attachView(_ view: StockDetailsProtocol) {
        self.view = view
    }
    
    func initializeElements(symbol: String, _ callback: @escaping (DateInfo?, Int?) -> Void){
        let model = GetInformation()
        let url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(symbol)&outputsize=compact&apikey=\(GlobalConstants.apiKey)"
        model.makeStockRequest(withURL: URL(string: url)!) { (rates, statusCode) in
            if GlobalConstants.STATUS_OK ~= statusCode!{
            callback(rates, statusCode)
            }
        }
    }
    
    func initializeElements(withInfo info: DateInfo){
        self.view?.initializeElements(withInfo: info)
    }
    
    func navigateBack(){
        self.view?.navigateBack()
    }
}

class CurrencyPresenter{
    fileprivate let model : GetInformation?
    weak private var view: CurrencyProtocol?
    
    init(info: GetInformation?) {
        self.model = info
    }
    
    func attachView(_ view: CurrencyProtocol) {
        self.view = view
    }
    
    func initializeUI(_ callback: @escaping (ExchangeRate?, Int?) -> Void) {
        let url = "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=CNY&apikey=\(GlobalConstants.apiKey)"
        
        model?.makeCurrencyRequest(withURL: URL(string: url)!, {
            (rate, statusCode) in
            if GlobalConstants.STATUS_OK ~= statusCode!{
            callback(rate, statusCode)
            }
        })
    }
    
    func initializeUI(withInfo info: ExchangeRate){
        self.view?.initializeUI(withInfo: info)
    }
    
    func addSwipe(){
        self.view?.addSwipe()
    }
}
