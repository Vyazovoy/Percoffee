//
//  CoffeeInfo.swift
//  Percoffee
//
//  Created by Andrew Vyazovoy on 03/09/2017.
//  Copyright © 2017 vyazovoy. All rights reserved.
//

import Foundation

struct CoffeeInfo: Codable {
    
    let identifier: String
    let name: String
    let info: String
    let imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case info = "desc"
        case imageURL = "image_url"
    }
    
}
