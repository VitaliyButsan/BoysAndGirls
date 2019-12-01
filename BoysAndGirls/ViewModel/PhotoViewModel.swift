//
//  PhotoViewModel.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 17.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import Foundation

class PhotoViewModel {
    
    static let notificationNameString: String = "PhotoDataIsReceived"
    var photos: [UnsplashPhoto] = []
    var photosRawData: [Data] = []
    
    
    func getPhotos(name: String, onPage: Int = 1) {
        NetworkManager.instance.request(searchingPhoto: name, onPage: onPage) { (data, _, error) in
            guard error == nil, let data = data else { return }
            
            let parsingResult = self.parseData(data: data)
            self.saveImagesFrom(parsingResult)
            //self.sendNotification()
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
                self.photosRawData.append(rawData)
                if saveTaskQueue.operations.isEmpty {
                    self.sendNotification()
                }
            }
            saveTaskQueue.addOperation(photoSaver)
        }
 
        
        /*
        DispatchQueue.global().async { [unowned self] in
            saveTaskQueue.addOperations(photoSaverOperations, waitUntilFinished: true)
            DispatchQueue.main.async {
                self.photosRawData.append(photoSaver.photoRawData!)
            }
        }
        */
        
        for photo in photoDataModel {
            self.photos.append(photo)
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
        
        guard let urlString = inputPhoto?.urls["small"],
              let url = URL(string: urlString),
              let imageData = try? Data(contentsOf: url) else { return }
        self.photoRawData = imageData
    }
}
