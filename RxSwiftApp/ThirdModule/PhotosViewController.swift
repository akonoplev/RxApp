//
//  3MPhotosViewController.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 17.08.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import Photos
import RxSwift

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var photos = PhotosViewController.loadPhotos()
    private lazy var imageManager = PHCachingImageManager()
    private lazy var thumbnailSize: CGSize = {
        let cellSize = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        return CGSize(width: cellSize.width * UIScreen.main.scale,
                      height: cellSize.height * UIScreen.main.scale)
    }()
    
    let bag = DisposeBag()
    private let selectedPhotosSubject = PublishSubject<UIImage>()
    var selectedPhotos: Observable<UIImage> {
        return selectedPhotosSubject.asObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let autorized = PHPhotoLibrary.authorized.share()
        
        autorized
            .skipWhile { $0 == false }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.photos = PhotosViewController.loadPhotos()
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }).disposed(by: bag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectedPhotosSubject.onCompleted()
    }
    
    class func loadPhotos()-> PHFetchResult<PHAsset> {
        let allOptions = PHFetchOptions()
        allOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return PHAsset.fetchAssets(with: allOptions)
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = self.photos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photos3ModuleCell", for: indexPath) as! Photos3ModuleCell
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset,
                                  targetSize: thumbnailSize,
                                  contentMode: .aspectFill,
                                  options: nil) { (image, _) in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageVIew.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = photos.object(at: indexPath.row)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? Photos3ModuleCell {
            cell.flash()
        }
        
        imageManager.requestImage(for: asset, targetSize: view.frame.size, contentMode: .aspectFill,
                                  options: nil) { [weak self] (image, info) in
                                    guard let image = image,
                                        let info = info else { return }
                                    if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool,  !isThumbnail {
                                        self?.selectedPhotosSubject.onNext(image)
                                    }
        }
    }
}
