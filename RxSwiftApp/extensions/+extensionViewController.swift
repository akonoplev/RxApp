//
//  +extensionViewController.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 17.08.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    func showAlert(title: String, description: String?) -> Observable<Void> {
        return Observable.create({ [weak self] observer in
            let alertVC = UIAlertController(title: title,
                                            message: description,
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Close",
                                            style: .default,
                                            handler: { _ in
                                                observer.onCompleted()
            }))
            self?.present(alertVC, animated: true, completion: nil)
            
            return Disposables.create(with: {
                self?.dismiss(animated: true, completion: nil)
            })
        })
    }
}
