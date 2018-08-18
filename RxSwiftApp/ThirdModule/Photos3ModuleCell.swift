//
//  Photos3ModuleCell.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 17.08.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

class Photos3ModuleCell: UICollectionViewCell {
    
    @IBOutlet weak var imageVIew: UIImageView!
    var representedAssetIdentifier: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageVIew.image = nil
    }
    
    func flash() {
        imageVIew.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.imageVIew.alpha = 1
        }
    }
}
