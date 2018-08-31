//
//  PHPhotoLibrary+rx.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 17.08.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import Photos
import RxSwift

extension PHPhotoLibrary {
    static var authorized: Observable<Bool> {
        return Observable.create { observer in
            DispatchQueue.main.async {
                if authorizationStatus() == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    requestAuthorization { newStatus in
                        observer.onNext(newStatus == .authorized)
                        observer.onCompleted()
                        
                    }
                }
            }
            return Disposables.create()
        }
    }
}
