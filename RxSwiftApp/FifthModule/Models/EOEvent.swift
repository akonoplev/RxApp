//
//  EOEvent.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 18.09.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import RxSwift

struct EOEvent {
    let id: String
    let title: String
    let description: String
    let link: URL?
    let closeDate: Date?
    let categories: [Int]
    let locations: [EOLocation]
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let title = json["title"] as? String,
            let description = json["description"] as? String,
            let link = json["link"] as? String,
            let closeDate = json["closed"] as? String,
            let categories = json["categories"] as? [[String: Any]] else {
                return nil
        }
        self.id = id
        self.title = title
        self.description = description
        self.link = URL(string: link)
        self.closeDate = EONET.ISODateReader.date(from: closeDate)
        self.categories = categories.flatMap { categoryDesc in
            guard let catID = categoryDesc["id"] as? Int else {
                return nil
            }
            return catID
        }
        if let geometries = json["geometries"] as? [[String: Any]] {
            locations = geometries.flatMap(EOLocation.init)
        } else {
            locations = []
        }
    }
    
    static func compareDates(lhs: EOEvent, rhs: EOEvent) -> Bool {
        switch (lhs.closeDate, rhs.closeDate) {
        case (nil, nil): return false
        case (nil, _): return true
        case (_, nil): return false
        case (let ldate, let rdate): return ldate! < rdate!
        }
    }
}
