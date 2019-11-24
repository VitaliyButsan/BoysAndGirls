//
//  DataModel.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 15.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//

import Foundation

struct PhotoDataWrapper: Decodable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let urls: [URLKind.RawValue: String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb 
    }
}


