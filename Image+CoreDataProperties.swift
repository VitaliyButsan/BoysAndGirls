//
//  Image+CoreDataProperties.swift
//  BoysAndGirls
//
//  Created by Vitaliy on 23.11.2019.
//  Copyright © 2019 Vitaliy. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var binaryData: Data?
    @NSManaged public var isSelected: Bool

}
