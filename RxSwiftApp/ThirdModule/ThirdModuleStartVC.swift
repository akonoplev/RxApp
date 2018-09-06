//
//  ThirdModuleStartVC.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 17/08/2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import RxSwift

class ThirdModuleStartVC: UIViewController {

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var imageCache = [Int]()
    private let bag = DisposeBag()
    private let images = Variable<[UIImage]>([])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesShared = images.asObservable().share()
        imagesShared
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (photos) in
            guard let preview = self?.previewImage else { return }
            preview.image = UIImage.collage(images: photos, size: preview.frame.size)
        }).disposed(by: bag)
        
        imagesShared.asObservable()
            .subscribe(onNext: { [weak self] (photos) in
                self?.updateUI(photos: photos)
            }).disposed(by: bag)
    }
    
    @IBAction func actionAdd() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "photosViewController") as! PhotosViewController
//        vc.selectedPhotos.subscribe(onNext: { [weak self] (newImage) in
//            guard let images = self?.images else { return }
//            images.value.append(newImage)
//            }, onDisposed: {
//                print("complete photo selection")
//        }).disposed(by: bag)
        
        let newPhotos = vc.selectedPhotos.share()
        
        newPhotos.filter { [weak self] (newImage) -> Bool in
            let len = UIImagePNGRepresentation(newImage)?.count ?? 0
            guard self?.imageCache.contains(len) == false else { return false }
            self?.imageCache.append(len)
            return true
            }.takeWhile{ [weak self] image in
                return (self?.images.value.count ?? 0) < 6
            }.subscribe(onNext: { [weak self] (newImage) in
                guard let images = self?.images else { return }
                images.value.append(newImage)
                }, onDisposed: {
                    print("complete phtot selection")
            }).disposed(by: bag)
        
        newPhotos
            .ignoreElements()
            .subscribe(onCompleted: {
                self.updateNavigationIcon()
            }, onError: nil).disposed(by: vc.bag)
        self.navigationController?.pushViewController(vc, animated: true)
        
        newPhotos.filter {  (newImage) -> Bool in
            return newImage.size.width > newImage.size.height
        }.subscribe(onNext: { newImage in
            print(newImage)
        }).disposed(by: bag)
    }
    
    func updateNavigationIcon()-> Void {
        let icon = previewImage
            .image?.scaled(CGSize(width: 22, height: 22))
            .withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .done, target: nil, action: nil)
    }
    
    @IBAction func actionClear() {
        images.value = []
         navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        guard let image = previewImage.image else { return }
        PhotoWriter.save1(image: image).subscribe(onSuccess: { [weak self] (id) in
            self?.showMessage("Сохранено", "saved with id: \(id)")
            self?.actionClear()
        }) { [weak self] (error) in
            self?.showMessage("Error", "Ошибкааааа")
        }.disposed(by: bag)
    }
    private func updateUI(photos: [UIImage]) {
        saveButton.isEnabled = photos.count > 2 && photos.count % 2 == 0
        clearButton.isEnabled = photos.count > 0
        addButton.isEnabled = photos.count < 6
        self.navigationItem.title = photos.count > 0 ? "\(photos.count) photos" : "make collage"
    }
    
    func showMessage(_ title: String, _ message: String) {
        self.showAlert(title: title, description: message)
            .subscribe()
            .disposed(by: bag)
    }

}
