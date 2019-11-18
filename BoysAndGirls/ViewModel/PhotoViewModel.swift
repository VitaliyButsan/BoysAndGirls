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
    
    func getPhotos(name: String) {
        NetworkManager.instance.request(searchingPhoto: name) { (data, _, error) in
            guard error == nil, let data = data else { return }
            self.parseData(data: data)
        }
    }
    
    private func parseData(data: Data) {
        do {
            let jsonData = try JSONDecoder().decode(PhotoDataWrapper.self, from: data)
            self.photos = jsonData.results
            self.sendNotification()
        } catch let error {
            print("Parsing Error: \(error.localizedDescription)")
        }
    }
    
    private func sendNotification() {
        let notificationName = Notification.Name(PhotoViewModel.notificationNameString)
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
}
