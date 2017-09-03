//
//  PercolateService.swift
//  Percoffee
//
//  Created by Andrew Vyazovoy on 03/09/2017.
//  Copyright © 2017 vyazovoy. All rights reserved.
//

import Foundation
import Moya

private let coffeeListJSONString = """
    [
        {
            "desc": "A coffee-based beverage or dessert. Usually refers to the act of topping a drink or dessert with esp...",
            "image_url": "http://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Affogato.JPG/800px-Affogato.JPG",
            "id": "affogato",
            "name": "Affogato"
        },
        {
            "desc": "A style of coffee prepared by adding hot water to espresso, giving a similar strength to but differe...",
            "image_url": "",
            "id": "americano",
            "name": "Caffe Americano"
        },
        {
            "desc": "A coffee-based drink prepared with espresso, hot milk, and steamed milk foam. A cappuccino differs f...",
            "image_url": "http://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Classic_Cappuccino.jpg/800px-Classic_Cappuccino.jpg",
            "id": "cappuccino",
            "name": "Cappuccino"
        },
        {
            "desc": "Refers to the process of steeping coffee grounds in room temperature or cold water for an extended p...",
            "image_url": "",
            "id": "coldbrew",
            "name": "Cold Brew"
        }
    ]
    """

private let coffeeJSONString = """
    {
        "desc": "Refers to the process of steeping coffee grounds in room temperature or cold water for an extended p...",
        "image_url": "",
        "id": "coldbrew",
        "name": "Cold Brew",
        "last_updated_at": "2017-08-25 16:05:57.411550"
    }
    """


enum PercolateService {
    case getCoffeeInfos
    case getCoffeeInfo(identifier: String)
}

extension PercolateService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://coffeeapi.percolate.com")!
    }
    var path: String {
        switch self {
        case .getCoffeeInfos:
            return "/api/coffee/"
        case .getCoffeeInfo(let identifier):
            let escapedIdentifier = identifier.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            return "/api/coffee/\(escapedIdentifier)/"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var sampleData: Data {
        switch self {
        case .getCoffeeInfos:
            return coffeeListJSONString.data(using: .utf8)!
        case .getCoffeeInfo(_):
            return coffeeJSONString.data(using: .utf8)!
        }
    }
    var task: Task {
        return .requestPlain
    }
    var headers: [String : String]? {
        return ["Authorization": "WuVbkuUsCXHPx3hsQzus4SE"]
    }
    
}
