//
//  FirstModuleStartVC.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 28.07.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import RxSwift

//MARK: - Obserable observer subscribe and dispose

class FirstModuleStartVC: UIViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Rx First Module"
//        example(of: "one, of, from") {
//            let one = 1
//            let two = 2
//            let three = 3
//
//            //operators
////            let observable: Observable<Int> = Observable<Int>.just(one)
////
////            let observable2 = Observable.of(one, two, three)
////
////            let observable3 = Observable.of([one, two, three])
////
////            let observable4 = Observable.from([one,two,three])
//        }
        
//        example(of: "subscribe") {
//            let one = 1
//            let two = 2
//            let three = 3
//
//            let observable = Observable.of(one, two, three)
//            observable.subscribe({ (event) in
//                print(event)
//
//                if let element = event.element {
//                    print(element)
//                }
//            })
//            //short
//            observable.subscribe(onNext: { (element) in
//                print(element)
//            })
//
//
//            let emptyObserable = Observable<Void>.empty()
//            emptyObserable.subscribe(onNext: { (element) in
//                print(element)
//            }, onCompleted: {
//                print("completed")
//            })
//        }
        

//        let sequence = 0..<3
//        var iterator = sequence.makeIterator()
//        
//        while let n = iterator.next() {
//            print(n)
//        }
        
//        example(of: "never") {
//            let observable = Observable<Void>.never()
//
//            let disposeBag = DisposeBag()
//
//            observable.subscribe(onNext: { (element) in
//                print(element)
//            }, onCompleted: {
//                print("completed")
//            }, onDisposed: {
//                print("adsf")
//            }).disposed(by: disposeBag)
//        }
        
//        example(of: "range") {
//            let observable = Observable<Int>.range(start: 0, count: 19)
//            observable.subscribe(onNext: { (element) in
//                let n = Double(element)
//                let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
//                print(fibonacci)
//
//            })
//        }
        
//        example(of: "dispose") {
//
//            let observable = Observable.of(1, 2, 14)
//
//            observable.subscribe(onNext: { (event) in
//                print(event)
//
//            }, onCompleted: {
//                print("complete")
//            })
//
//            .dispose()
//        }
//
//        example(of: "DisposeBag") {
//            let disposeBag = DisposeBag()
//
//            Observable.of("A", "B", "C").subscribe {
//                print($0)
//            }
//
//            .disposed(by: disposeBag)
//        }
        
        
//        example(of: "create") {
//            let disposeBag = DisposeBag()
//
//            enum MyError: Error {
//                case aError
//            }
//
//            Observable<String>.create({ observer in
//                observer.onNext("first")
//                observer.onError(MyError.aError)
//                observer.onCompleted()
//                observer.onNext("?")
//
//                return Disposables.create()
//            }).subscribe(
//                onNext: { print($0)},
//                onError: { print($0)},
//                onCompleted: { print("on Complete")},
//                onDisposed: { print("Disposed") }
//                ).disposed(by: disposeBag)
//        }
        
//        example(of: "observable factories") {
//            let disposeBag = DisposeBag()
//            var flip = false
//            
//            let factory: Observable<Int> = Observable.deferred {
//                flip = !flip
//                
//                if flip {
//                    return Observable.of(1,2,3)
//                } else {
//                    return Observable.of(3,4,5)
//                }
//            }
//            
//            for _ in 0...5 {
//                factory.subscribe(onNext: { print($0, terminator: "") }).disposed(by: disposeBag)
//                print()
//            }
//            
//        }
        
//        example(of: "single trait") {
//            let disposeBag = DisposeBag()
//
//            enum FileReaderError: Error {
//                case fileNotFound, unreadable, encodingFailed
//            }
//
//            func loadText(from name: String)-> Single<String> {
//                return Single.create(subscribe: { (single) -> Disposable in
//                    let disposable = Disposables.create()
//                    guard let path =  Bundle.main.path(forResource: name , ofType: "txt") else {
//                        single(.error(FileReaderError.fileNotFound))
//                        return disposable
//                    }
//
//                    guard let data = FileManager.default.contents(atPath: path) else {
//                        single(.error(FileReaderError.unreadable))
//                        return disposable
//                    }
//
//                    guard let content = String(data: data, encoding: .utf8) else {
//                        single(.error(FileReaderError.encodingFailed))
//                        return disposable
//                    }
//
//                    single(.success(content))
//                    return disposable
//                })
//            }
//
//            loadText(from: "Something").subscribe() {
//                switch $0 {
//                case .error(let error):
//                    print(error)
//                case .success(let string):
//                    print(string)
//                }
//            }.disposed(by: disposeBag)
//        }
        
        
//        example(of: "do operator") {
//
//            let disposeBag = DisposeBag()
//
//            let observable = Observable<String>.of("А", "B", "C")
//
//            let o = observable.do(onNext: {
//                if $0 == "B" {
//                    print("Удача")
//                } else {
//                    print($0)
//                }
//            }, onCompleted: { print("completed")}, onSubscribe: { print("subscribe") }, onDispose: { print("Disposed")})
//
//            o.subscribe().disposed(by: disposeBag)
//        }
//        
//        
    }

    



    func example(of description: String, action: ()-> Void)-> Void {
        print("\(description)")
        action()
    }
}
