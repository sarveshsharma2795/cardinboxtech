//
//  StockDetailsTableCellTableViewCell.swift
//  Cardinbox tech round
//
//  Created by Sarvesh on 20/02/19.
//  Copyright © 2019 Sarvesh. All rights reserved.
//

import UIKit

class StockDetailsTableCellTableViewCell: UITableViewCell {

    @IBOutlet var date: UILabel!
    @IBOutlet var volume: UILabel!
    @IBOutlet var closePrice: UILabel!
    @IBOutlet var lowPrice: UILabel!
    @IBOutlet var highPrice: UILabel!
    @IBOutlet var openPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
