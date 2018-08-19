//
//  PhotoWriter.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 19.08.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import Photos

class PhotoWriter: NSObject {
    
    class func save(image: UIImage)-> Observable<String> {
        return Observable.create({ observer  in
            var saveAssetID: String?
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                saveAssetID = request.placeholderForCreatedAsset?.localIdentifier
            }, completionHandler: { (success, error) in
                DispatchQueue.main.async {
                    if success, let id = saveAssetID {
                        observer.onNext(id)
                        observer.onCompleted()
                    } else {
                        observer.onError(error!)
                    }
                }
            })
            return Disposables.create()
        })
    }
    
    //with use Single
    
    class func save1(image: UIImage)-> Single<String> {
        enum SaveError: Error {
            case failedError, unexpectedIDError
        }
        
        return Single.create(subscribe: { (single) -> Disposable in
            var saveAssetId: String?
            let disposable = Disposables.create()
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                saveAssetId = request.placeholderForCreatedAsset?.localIdentifier
            }, completionHandler: { (success, error) in
                DispatchQueue.main.async {
                    if success, let id = saveAssetId {
                        single(.success(id))
                    } else {
                        single(.error(SaveError.failedError))
                    }
                }
            })
            return disposable
        })
    }
}
