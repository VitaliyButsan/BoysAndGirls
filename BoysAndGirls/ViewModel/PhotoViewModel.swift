//
//  PhotoViewModel.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 17.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import UIKit

class PhotoViewModel {
    
    static var notificationNameString: String = "PhotoDataIsReceived"
    private var photoName: String = ""
    var photos: [UIImage] = []
    
    func getPhotos(name: String, onPage: Int = 1) {
        self.photoName = name
        
        NetworkManager.instance.request(photoName: name, onPage: onPage) { (data, _, error) in
            guard error == nil, let data = data else { return }
            
            let parsingResult = self.parse(data: data)
            self.saveImagesFrom(parsingResult)
        }
    }
    
    private func parse(data: Data) -> [UnsplashPhoto] {
        do {
            let jsonData = try JSONDecoder().decode(PhotoDataWrapper.self, from: data)
            return jsonData.results
        } catch let error {
            print("Parsing Error: \(error.localizedDescription)")
            return []
        }
    }

    private func saveImagesFrom(_ photoDataModels: [UnsplashPhoto]) {
        
        let privateSerialQueue = DispatchQueue(label: "com.private_serial_queue", qos: .userInitiated)
        
        let receivePhotosTaskQueue: OperationQueue = {
            let queue = OperationQueue()
            queue.name = "Receive photos queue"
            queue.maxConcurrentOperationCount = 1
            queue.underlyingQueue = privateSerialQueue
            return queue
        }()
        
        for photoModel in photoDataModels {
            // make instance of operation
            let photoReceiver = PhotoDataReceiverOperation()
            photoReceiver.inputPhotoModel = photoModel
            // add operation on queue
            receivePhotosTaskQueue.addOperation(photoReceiver)
            
            // wait for done of each operation in queue
            photoReceiver.completionBlock = { [unowned self] in
                guard let rawData = photoReceiver.receivedPhotoRawData else { return }
                guard let image = UIImage(data: rawData) else { return }
                self.photos.append(image)
                print("received_photos_from_net:", self.photos.count)
                
                // send notification if all operation is done on queue
                if receivePhotosTaskQueue.operations.isEmpty {
                    self.sendNotification()
                }
            }
        }
    }
    
    private func sendNotification() {
        let notificationName = Notification.Name(self.photoName + PhotoViewModel.notificationNameString)
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
}

class PhotoDataReceiverOperation: Operation {
    
    var inputPhotoModel: UnsplashPhoto?
    var receivedPhotoRawData: Data?

    override func main() {
        
        guard let urlString = inputPhotoModel?.urls["thumb"],
              let url = URL(string: urlString),
              let receivedImageData = try? Data(contentsOf: url) else { return }
        
        self.receivedPhotoRawData = receivedImageData
    }
}
