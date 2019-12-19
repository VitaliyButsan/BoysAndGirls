//
//  GirlsCollectionViewController.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 21.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class GirlsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .systemBlue
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    
        // Configure the cell
    
        return cell
    }
}
