//
//  +StoryboardExtension.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 28.07.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit

enum Storyboards: String {
    case first = "First"
    case second = "Second"
    case third = "Third"
    case fourth = "Fourth"
    case fifth = "Fifth"
    case wundercust = "Main"
}

extension UIStoryboard {
    static func create(_ storyboard: Storyboards, bundleName: String?)-> UIStoryboard {
        let bundle: Bundle? = bundleName == nil ? nil : Bundle(identifier: bundleName ?? "")
        return UIStoryboard.init(name: storyboard.rawValue, bundle: bundle)
    }
}
