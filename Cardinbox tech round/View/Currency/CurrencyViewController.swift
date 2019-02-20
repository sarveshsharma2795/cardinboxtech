//
//  CurrencyViewController.swift
//  Cardinbox tech round
//
//  Created by Sarvesh on 20/02/19.
//  Copyright © 2019 Sarvesh. All rights reserved.
//

import UIKit
import UserNotifications

class CurrencyViewController: UIViewController {

    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var exchangeRate: UILabel!
    var currencyModel : ExchangeRate?
    let presenter = CurrencyPresenter(info: GetInformation())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        presenter.addSwipe()
        presenter.initializeUI {
            (rate, statusCode) in
            self.presenter.initializeUI(withInfo: rate!)
        }
    }
    
    @objc func handleSwipe(gesture: UIGestureRecognizer){
        presenter.initializeUI {
            (rate, statusCode) in
            self.presenter.initializeUI(withInfo: rate!)
        }
    }
}

extension CurrencyViewController: CurrencyProtocol{
    
    func initializeUI(withInfo info: ExchangeRate) {
        self.currencyModel = info
        DispatchQueue.main.async {
            self.fromLabel.text = "From: " + (self.currencyModel?.exchangeKey.fromCurrency ?? "")
            self.toLabel.text = "To: " + (self.currencyModel?.exchangeKey.toCurrency ?? "")
            self.exchangeRate.text = "Exchange rate: " + (self.currencyModel?.exchangeKey.exchangeRate ?? "")
            let center =  UNUserNotificationCenter.current()
            
            //create the content for the notification
            let content = UNMutableNotificationContent()
            content.title = " Currency rate"
            content.subtitle = "BTC TO CNY"
            content.body = "\((self.currencyModel?.exchangeKey.exchangeRate ?? ""))"
            content.sound = UNNotificationSound.default
            
            //notification trigger can be based on time, calendar or location
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:300.0, repeats: true)
            
            //create request to display
            let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
            
            //add request to notification center
            center.add(request) { (error) in
                if error != nil {
                    print("error \(String(describing: error))")
                }
            }
        }
    }
    
    func addSwipe() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
}
