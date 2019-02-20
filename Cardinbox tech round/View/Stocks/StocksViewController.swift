//
//  ViewController.swift
//  Cardinbox tech round
//
//  Created by Sarvesh on 20/02/19.
//  Copyright © 2019 Sarvesh. All rights reserved.
//

import UIKit

class StocksViewController: UIViewController {
    
    @IBOutlet var stocksTableView: UITableView!
    let presenter = StocksPresenter(info: GetInformation())
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        presenter.attachView(self)
        presenter.initializeElements()
    }
}

extension StocksViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StocksTableCell", for: indexPath) as! StocksTableCell
        switch indexPath.row {
        case 0:
            cell.brandsLabel.text = "Microsoft"
        case 1:
            cell.brandsLabel.text = "Apple"
        default:
            break
        }
//        if indexPath.row == 0{
//            cell.brandsLabel.text = "Microsoft"
//        }
//        else if indexPath.row == 1{
//            cell.brandsLabel.text = "Apple"
//        }
        //        switch indexPath.row {
        //        case 0:
        //            cell.brandButton.titleLabel?.text = "Microsoft"
        //            cell.backgroundColor = .yellow
        //        case 1:
        //            cell.brandButton.titleLabel?.text = "Apple"
        //            cell.backgroundColor = .green
        //        default:
        //            break
        //        }
        //        var stocksDataKeys = [String]()
        //        if let stocksDict = stocksData?.timeSeries{
        //            stocksDataKeys = Array(stocksDict.keys)
        //        }
        //        //        cell.volumeLabel.text = stocksData?.timeSeries?[stocksDataKeys[indexPath.row]]?.volume
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let stockDetailsVC = StockDetailsViewViewController()
            stockDetailsVC.symbol = "MSFT"
            self.present(stockDetailsVC, animated: true, completion: nil)
        case 1:
            let stockDetailsVC = StockDetailsViewViewController()
            stockDetailsVC.symbol = "AAPL"
            self.present(stockDetailsVC, animated: true, completion: nil)
        default:
            break
        }
    }
}
extension StocksViewController: StocksProtocol{
    func initializeElements() {
        stocksTableView.register(UINib.init(nibName: "StocksTableCell", bundle: nil), forCellReuseIdentifier: "StocksTableCell")
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.separatorStyle = .none
    }
}
