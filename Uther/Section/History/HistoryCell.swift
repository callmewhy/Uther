//
//  HistoryCell.swift
//  Uther
//
//  Created by why on 8/13/15.
//  Copyright (c) 2015 callmewhy. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!

    func update(text: String, seperatorHidden: Bool) {
        messageLabel.text = text
    }
    
}