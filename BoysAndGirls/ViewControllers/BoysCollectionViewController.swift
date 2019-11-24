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
        static let imageSize: String = "small"
        
        static let leadingSectionIndent: CGFloat = 8.0
        static let trailingSectionIndent: CGFloat = 8.0
        static let leadingTrailingSectionIndent: CGFloat = leadingSectionIndent + trailingSectionIndent
        static let cellSpasing: CGFloat = 4.0
        static let cellsInRow: CGFloat = 2
        static let allCellsSpasing: CGFloat = cellSpasing * (cellsInRow - 1)
    }
    
    let photoModel = PhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.backgroundColor = .lightGray
        self.setupObservers()
        photoModel.getPhotos(name: Constants.searchingString)
    }
    
    // waiting photos
    private func setupObservers() {
        let notificationName = NSNotification.Name(rawValue: PhotoViewModel.notificationNameString)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: notificationName, object: nil)
    }
    
    @objc func reloadRows() {
        self.collectionView.reloadData()
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
    
    
}

// MARK: - UICollectionView data source

extension BoysCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModel.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as! BoyCollectionViewCell
        
        if let imageURLString = photoModel.photos[indexPath.row].urls[Constants.imageSize] {
            cell.imageURL = URL(string: imageURLString)
        }
        
        return cell
    }
}

// MARK: - UICollectionView delegate flow layout

extension BoysCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frameWidth = self.view.frame.width
        let sectionIndents = Constants.leadingTrailingSectionIndent
        let cellsSpasing = Constants.allCellsSpasing
        let cellsPerRow = Constants.cellsInRow
        
        let cellWidth: CGFloat = (frameWidth - sectionIndents - cellsSpasing) / cellsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Constants.leadingSectionIndent, bottom: 0, right: Constants.trailingSectionIndent)
    }
}
