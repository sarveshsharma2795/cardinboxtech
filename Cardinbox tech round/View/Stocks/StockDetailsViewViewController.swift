//
//  StockDetailsViewViewController.swift
//  Cardinbox tech round
//
//  Created by Sarvesh on 20/02/19.
//  Copyright © 2019 Sarvesh. All rights reserved.
//

import UIKit

class StockDetailsViewViewController: UIViewController {

    @IBOutlet var stockDetailsTable: UITableView!
    var stocksData: DateInfo?
    var symbol = String()
    let presenter = StockDetailsaPresenter(info: GetInformation())
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        stockDetailsTable.register(UINib.init(nibName: "StockDetailsTableCellTableViewCell", bundle: nil), forCellReuseIdentifier: "StockDetailsTableCellTableViewCell")
        presenter.initializeElements(symbol: symbol) {
            (rates, statusCode) in
            self.presenter.initializeElements(withInfo: rates!)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        presenter.navigateBack()
    }
}

extension StockDetailsViewViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockDetailsTableCellTableViewCell", for: indexPath) as! StockDetailsTableCellTableViewCell
        var stocksDataKeys = [String]()
        if let stocksDict = stocksData?.timeSeries{
            stocksDataKeys = Array(stocksDict.keys)
        }
        if stocksDataKeys.count != 0{
        stocksDataKeys.sort {
                (a, b) -> Bool in
                return a > b
            }
         let date = stocksDataKeys[indexPath.row]
        cell.date.text = date
        }
        cell.selectionStyle = .none
        cell.highPrice.text = "High price: " + (stocksData?.timeSeries?[stocksDataKeys[indexPath.row]]?.highPrice ?? "")
        cell.lowPrice.text = "Low price: " + (stocksData?.timeSeries?[stocksDataKeys[indexPath.row]]?.lowPrice ?? "")
        cell.openPrice.text = "Open price: " + (stocksData?.timeSeries?[stocksDataKeys[indexPath.row]]?.openPrice ?? "")
        cell.closePrice.text = "Close price: " + (stocksData?.timeSeries?[stocksDataKeys[indexPath.row]]?.closePrice ?? "")
        cell.volume.text = "Volume: " + (stocksData?.timeSeries?[stocksDataKeys[indexPath.row]]?.volume ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}
extension StockDetailsViewViewController: StockDetailsProtocol{
    
    func initializeElements(withInfo info: DateInfo) {
        stockDetailsTable.delegate = self
        stockDetailsTable.dataSource = self
        stockDetailsTable.separatorStyle = .none
        self.stocksData = info
        self.stockDetailsTable.reloadData()
    }
    
    func navigateBack(){
        self.dismiss(animated: true, completion: nil)
    }
}
