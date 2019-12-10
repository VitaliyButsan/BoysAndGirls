//
//  ViewController.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 15.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class BoysCollectionViewController: UICollectionViewController {
    
    private struct Constants {
        static let searchingString: String = "boy"
        static let cellID: String = "BoyCell"
        static let imageSize: String = "thumb"
        
        static let leadingSectionIndent: CGFloat = 8.0
        static let trailingSectionIndent: CGFloat = 8.0
    }
    
    let photoModel = PhotoViewModel()
    var isPagging: Bool = false
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        self.collectionView.backgroundColor = .lightText
        self.setupObservers()
        photoModel.getPhotos(name: Constants.searchingString, onPage: page)
    }
    
    // waiting retrieve data
    private func setupObservers() {
        let notificationName = NSNotification.Name(rawValue: PhotoViewModel.notificationNameString)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: notificationName, object: nil)
    }
    
    @objc func reloadRows() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        self.isPagging = false
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.collectionView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UICollectionView delegate

extension BoysCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoModel.photos.remove(at: indexPath.row)
        let newIndexPath = IndexPath(row: indexPath.row, section: 0)
        collectionView.deleteItems(at: [newIndexPath])
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // pagination
        print(indexPath.row, photoModel.photos.count - 1)
        if indexPath.row == photoModel.photos.count - 1, !isPagging {
            isPagging = true
            page = page + 1
            //photoModel.getPhotos(name: Constants.searchingString, onPage: page)
        }
    }
}

// MARK: - UICollectionView data source

extension BoysCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModel.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as! BoyCollectionViewCell

        cell.imageView.image = photoModel.photos[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionView delegate flow layout

extension BoysCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Constants.leadingSectionIndent, bottom: 0, right: Constants.trailingSectionIndent)
    }
}

// MARK: - PinterestLayoutDelegate

extension BoysCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return photoModel.photos[indexPath.item].size.height
    }
}
