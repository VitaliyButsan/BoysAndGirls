//
//  GirlsCollectionViewController.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 21.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit
import AVFoundation

class GirlsCollectionViewController: UICollectionViewController {

    private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    private var isPagging: Bool = false
    private var pageNumber: Int = 1
    
    fileprivate let photoModel: PhotoViewModel = PhotoViewModel()
    fileprivate let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private struct Constants {
        static let photoName: String = "Girl face"
        static let titleText: String = "Girls"
        
        static let headerViewHeight: CGFloat = 30.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpHeaderView()
        self.setUpObservers()
        self.getData(byName: Constants.photoName, onPage: pageNumber)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.setLayoutDelegate()
        self.setTabBarImageRenderingMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if photoModel.photos.isEmpty {
            self.addActivityIndicator()
        }
    }
    
    private func addActivityIndicator() {
        self.view.addSubview(self.activityIndicatorView)
        
        self.activityIndicatorView.hidesWhenStopped = true
        self.activityIndicatorView.center = self.view.center
        self.activityIndicatorView.startAnimating()
    }
    
    private func removeActivityIndicator() {
        self.activityIndicatorView.removeFromSuperview()
        self.activityIndicatorView.stopAnimating()
    }
    
    private func setTabBarImageRenderingMode() {
        if tabBarItem != nil {
            tabBarItem.image = tabBarItem.image?.withRenderingMode(.alwaysTemplate)
            tabBarItem.selectedImage = tabBarItem.selectedImage?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    private func setUpHeaderView() {
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId)
    }
    
    private func setUpObservers() {
        let notificationName = NSNotification.Name(rawValue: Constants.photoName + PhotoViewModel.notificationNameString)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: notificationName, object: nil)
    }
    
    @objc func reloadRows() {
        DispatchQueue.main.async {
            self.removeActivityIndicator()
            self.collectionView.reloadData()
        }
        self.isPagging = false
    }
    
    private func getData(byName photoName: String, onPage: Int) {
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

extension GirlsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
        // pagination
        if indexPath.item == photoModel.photos.count - 1, !isPagging {
            isPagging = true
            pageNumber += 1
            self.getData(byName: Constants.photoName, onPage: pageNumber)
        }
    }
}

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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseId, for: indexPath) as? HeaderView else { return UICollectionReusableView() }
            headerView.titleLabel.text = Constants.titleText
            return headerView
        default:
            fatalError()
        }
    }
}

// MARK: - Collection view delegate flow layout

extension GirlsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Constants.headerViewHeight)
    }
}

// MARK: - ProsentLayoutDelegate

extension GirlsCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return self.photoModel.photos[indexPath.item].size.height
    }
}
