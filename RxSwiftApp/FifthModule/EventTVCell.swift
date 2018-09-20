//
//  TableViewCell.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 19.09.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class EventTVCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(event: EOEvent)-> Void {
        self.titleLabel.text = event.title
        self.descriptionLabel.text = event.description
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        if let when = event.closeDate {
            self.dateLabel.text = formatter.string(from: when)
        } else {
            self.dateLabel.text = ""
        }
    }
}
