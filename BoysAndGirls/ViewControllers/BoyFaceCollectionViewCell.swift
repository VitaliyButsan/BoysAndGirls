//
//  BoyFaceCollectionViewCell.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 17.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class BoyFaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: URL? {
        didSet {
            self.imageView.image = nil
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let url = self.imageURL {
            self.spinner.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.imageView.image = UIImage(data: imageData)
                        }
                    }
                    
                    self.spinner.stopAnimating()
                }
            }
        }
    }
}
