//
//  GirlsCollectionViewController.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 21.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class GirlsCollectionViewController: UICollectionViewController {

    private struct Constants {
        static let photoName: String = "Girl face"
    }
    
    let photoModel = PhotoViewModel()
    let page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayoutDelegate()
        self.setUpObservers()
        self.getData(withPhotoName: Constants.photoName, onPage: page)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    private func setUpObservers() {
        let notificationName = NSNotification.Name(rawValue: Constants.photoName + PhotoViewModel.notificationNameString)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: notificationName, object: nil)
    }
    
    @objc func reloadRows() {
        print("girl_data_is_received! Ok!")
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func getData(withPhotoName photoName: String, onPage: Int) {
        self.photoModel.getPhotos(name: photoName, onPage: onPage)
    }
    
    private func setLayoutDelegate() {
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MAKR: - Collection view delegate



// MARK: - Collection view data source

extension GirlsCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoModel.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GirlCollectionViewCell.cellId, for: indexPath) as! GirlCollectionViewCell
    
        cell.imageView.image = self.photoModel.photos[indexPath.row]
        return cell
    }
}

// MARK: - Collection view delegate flow layout



// MARK: - ProsentLayoutDelegate

extension GirlsCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return self.photoModel.photos[indexPath.item].size.height
    }
}
