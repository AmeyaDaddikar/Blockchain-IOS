//
//  TransactionCell.swift
//  VJTI Blockchain
//
//  Created by Ameya Daddikar on 23/05/19.
//  Copyright © 2019 Veermata Jijabai Technological Institute. All rights reserved.
//

import Foundation
import UIKit
import IGIdenticon

class TransactionCell : UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var transactionAmtLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var senderIdenticon: UIImageView!
    
    func setRow(message: String, amount: Int, timestamp: Int, sender: String) {
        messageLabel?.text = message
        transactionAmtLabel?.text = "\(amount)"
        timestampLabel?.text = "\(timestamp)";
        senderIdenticon?.image = GitHubIdenticon().icon(
            from: sender,
            size: CGSize(width: 100, height: 100)
        )
        
    }
}
