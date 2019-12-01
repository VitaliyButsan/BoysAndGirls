//
//  PhotoViewModel.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 17.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class PhotoViewModel {
    
    static let notificationNameString: String = "PhotoDataIsReceived"
    var photos: [UIImage] = []
    
    func getPhotos(name: String, onPage: Int = 1) {
        NetworkManager.instance.request(searchingPhoto: name, onPage: onPage) { (data, _, error) in
            guard error == nil, let data = data else { return }
            
            let parsingResult = self.parseData(data: data)
            self.saveImagesFrom(parsingResult)
        }
    }
    
    private func parseData(data: Data) -> [UnsplashPhoto] {
        do {
            let jsonData = try JSONDecoder().decode(PhotoDataWrapper.self, from: data)
            return jsonData.results
        } catch let error {
            print("Parsing Error: \(error.localizedDescription)")
            return []
        }
    }

    private func saveImagesFrom(_ photoDataModel: [UnsplashPhoto]) {
        
        let privateSerialQueue = DispatchQueue(label: "com.private.queue", qos: .userInitiated)
        
        let saveTaskQueue: OperationQueue = {
            let queue = OperationQueue()
            queue.name = "Save perform queue"
            queue.maxConcurrentOperationCount = 1
            queue.underlyingQueue = privateSerialQueue
            return queue
        }()
        
        for photo in photoDataModel {
            // make instance of operation
            let photoSaver = PhotoSaverOperation()
            photoSaver.inputPhoto = photo
            // wait for done of each operation in queue
            photoSaver.completionBlock = { [unowned self] in
                guard let rawData = photoSaver.photoRawData else { return }
                guard let image = UIImage(data: rawData) else { return }
                self.photos.append(image)
                
                if saveTaskQueue.operations.isEmpty {
                    self.sendNotification()
                }
            }
            saveTaskQueue.addOperation(photoSaver)
        }
    }
    
    private func sendNotification() {
        let notificationName = Notification.Name(PhotoViewModel.notificationNameString)
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
}

class PhotoSaverOperation: Operation {
    
    var inputPhoto: UnsplashPhoto?
    var photoRawData: Data?

    override func main() {
        
        guard let urlString = inputPhoto?.urls["thumb"],
              let url = URL(string: urlString),
              let imageData = try? Data(contentsOf: url) else { return }
        self.photoRawData = imageData
    }
}
