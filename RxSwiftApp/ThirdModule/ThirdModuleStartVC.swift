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
    
    private let bag = DisposeBag()
    private let images = Variable<[UIImage]>([])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images.asObservable()
            .subscribe(onNext: { [weak self] (photos) in
            guard let preview = self?.previewImage else { return }
            preview.image = UIImage.collage(images: photos, size: preview.frame.size)
        }).disposed(by: bag)
        
        images.asObservable()
            .subscribe(onNext: { [weak self] (photos) in
                self?.updateUI(photos: photos)
            }).disposed(by: bag)
    }
    
    @IBAction func actionAdd() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "photosViewController") as! PhotosViewController
        vc.selectedPhotos.subscribe(onNext: { [weak self] (newImage) in
            guard let images = self?.images else { return }
            images.value.append(newImage)
            }, onDisposed: {
                print("complete photo selection")
        }).disposed(by: bag)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionClear() {
        images.value = []
    }
    
    private func updateUI(photos: [UIImage]) {
        saveButton.isEnabled = photos.count > 6 && photos.count % 2 == 0
        clearButton.isEnabled = photos.count > 0
        addButton.isEnabled = photos.count < 6
        self.navigationItem.title = photos.count > 0 ? "\(photos.count) photos" : "make collage"
    }
    

}
