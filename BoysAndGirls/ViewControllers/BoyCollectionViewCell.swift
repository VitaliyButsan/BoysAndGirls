//
//  BoyFaceCollectionViewCell.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 17.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class BoyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.cornerRadius = 10
        self.imageView.layer.masksToBounds = true 
    }
}
