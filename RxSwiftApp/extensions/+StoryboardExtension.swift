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
}

extension UIStoryboard {
    static func create(_ storyboard: Storyboards)-> UIStoryboard {
        return UIStoryboard.init(name: storyboard.rawValue, bundle: nil)
    }
}
