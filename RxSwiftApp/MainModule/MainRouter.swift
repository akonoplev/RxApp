//
//  MainRouter.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 28.07.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import UIKit
import Wundercust


class MainRouter {
    enum destination {
        case first
        case second
        case third
        case fourth
        case fifth
        case wundercust
    }
    
    private enum storyboards {
        static let first = UIStoryboard.create(.first, bundleName: nil)
        static let second = UIStoryboard.create(.second, bundleName: nil)
        static let third = UIStoryboard.create(.third, bundleName: nil)
        static let fourth = UIStoryboard.create(.fourth, bundleName: nil)
        static let fifth = UIStoryboard.create(.fifth, bundleName: nil)
        static let wundercust = UIStoryboard.create(.wundercust, bundleName: "beetlab.Wundercust")
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
        case .fourth:
            return createFourthModuleVC()
        case .fifth:
            return createFifthModuleVC()
        case .wundercust:
            return createWundercustVC()
        }
    }
    
}

extension MainRouter {
    private func createFirstModulVC()-> UIViewController {
        let vc = storyboards.first.instantiateViewController(withIdentifier: "firstModuleStoryboard")
        return vc
    }
    
    private func createSecondModuleVC()-> UIViewController {
        let vc = storyboards.second.instantiateViewController(withIdentifier: "secondModuleVC")
        return vc
    }
    
    private func createThirdModuleVC()-> UIViewController {
        let vc = storyboards.third.instantiateViewController(withIdentifier: "thirdModuleStartvC")
        return vc
    }
    
    private func createFourthModuleVC()-> UIViewController {
        let vc = storyboards.fourth.instantiateViewController(withIdentifier: "fourthStartVC")
        return vc
    }
    
    private func createFifthModuleVC()-> UIViewController {
        let vc = storyboards.fifth.instantiateViewController(withIdentifier: "fifthStartVC")
        return vc
    }
    
    private func createWundercustVC()-> UIViewController {
        let vc = storyboards.wundercust.instantiateViewController(withIdentifier: "wundercustStartVC")
        return vc
    }
}
