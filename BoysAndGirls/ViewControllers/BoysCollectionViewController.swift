//
//  ViewController.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 15.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class BoysCollectionViewController: UICollectionViewController {
    
    var isPagging: Bool = false
    var page: Int = 1
    
    private struct Constants {
        static let searchingString: String = "man face"
        static let cellID: String = "BoyCell"
        static let imageSize: String = "thumb"
        static let headerViewHeight: CGFloat = 30.0
        
        static let leadingSectionIndent: CGFloat = 8.0
        static let trailingSectionIndent: CGFloat = 8.0
    }
    
    let photoModel = PhotoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpHeaderView()
        self.setupObservers()
        self.getData(byName: Constants.searchingString, onPage: page)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setLayoutDelegate()
    }
    
    private func setLayoutDelegate() {
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    private func setUpHeaderView() {
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId)
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
    
    private func getData(byName name: String, onPage page: Int) {
        photoModel.getPhotos(name: name, onPage: page)
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
        self.photoModel.photos.remove(at: indexPath.row)
        let indexPathToDelete = IndexPath(row: indexPath.row, section: 0)
        collectionView.deleteItems(at: [indexPathToDelete])
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // pagination
        if indexPath.row == photoModel.photos.count - 1, !isPagging {
            isPagging = true
            page = page + 1
            self.getData(byName: Constants.searchingString, onPage: page)
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId, for: indexPath) as? HeaderView else { return UICollectionReusableView () }
            header.labelView.text = "Boys"
            return header
            
        default:
            return UICollectionReusableView()
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Constants.headerViewHeight)
    }
}

// MARK: - PinterestLayoutDelegate

extension BoysCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return photoModel.photos[indexPath.item].size.height
    }
}
