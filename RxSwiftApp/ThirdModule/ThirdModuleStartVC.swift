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
    
    @IBAction func savePhoto(_ sender: Any) {
        guard let image = previewImage.image else { return }
//        PhotoWriter.save(image: image).asSingle().subscribe(onSuccess: { [weak self] (id) in
//            self?.showMessage("Сохранено", "saved with id: \(id)")
//            self?.actionClear()
//        }) { [weak self] (error) in
//            self?.showMessage("Error", error.localizedDescription)
//        }.disposed(by: bag)
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
