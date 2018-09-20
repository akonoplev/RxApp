//
//  EOError.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 18.09.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation

enum EOError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
}
