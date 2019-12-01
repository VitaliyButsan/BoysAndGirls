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
    var isPagging: Bool = false
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.collectionView.backgroundColor = .red
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // pagination
        if indexPath.row == photoModel.photos.count - 1, !isPagging {
            isPagging = true
            page = page + 1
            photoModel.getPhotos(name: Constants.searchingString, onPage: page)
        }
    }
}

// MARK: - UICollectionView data source

extension BoysCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModel.photosRawData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as! BoyCollectionViewCell
        
        cell.contentMode = .scaleAspectFill
        let data = photoModel.photosRawData[indexPath.row]
        cell.imageView.image = UIImage(data: data)
        
        //if let imageURLString = photoModel.photos[indexPath.row].urls[Constants.imageSize] {
            //cell.imageURL = URL(string: imageURLString)
        //}
        
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
