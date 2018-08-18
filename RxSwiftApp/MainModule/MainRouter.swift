//
//  MainRouter.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 28.07.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import UIKit

class MainRouter {
    enum destination {
        case first
        case second
        case third
    }
    
    private enum storyboards {
        static let first = UIStoryboard.create(.first)
        static let second = UIStoryboard.create(.second)
        static let third = UIStoryboard.create(.third)
    }
    
    //Navigation
    public func navigateModally(to destination: destination, navigationController: UINavigationController) {
        let viewController = makeViewController(for: destination)
        let navController = UINavigationController()
        navController.pushViewController(viewController, animated: false)
        navigationController.present(navController, animated: false, completion: nil)
    }
    
    public func navigate(to destination: destination, navigationController: UINavigationController) {
        let vc = makeViewController(for: destination)
        navigationController.pushViewController(vc, animated: true)
    }
    
    public func makeViewController(for destination: destination)-> UIViewController {
        switch destination {
        case .first:
            return createFirstModulVC()
        case .second:
            return createSecondModuleVC()
        case .third:
            return createThirdModuleVC()
        }
    }
    
}

extension MainRouter {
    public func createFirstModulVC()-> UIViewController {
        let vc = storyboards.first.instantiateViewController(withIdentifier: "firstModuleStoryboard") as! FirstModuleStartVC
        return vc
    }
    
    public func createSecondModuleVC()-> UIViewController {
        let vc = storyboards.second.instantiateViewController(withIdentifier: "secondModuleVC") as! SecondModuleVC
        return vc
    }
    
    public func createThirdModuleVC()-> UIViewController {
        let vc = storyboards.third.instantiateViewController(withIdentifier: "thirdModuleStartvC") as! ThirdModuleStartVC
        return vc
    }
}
