//
//  SecondModuleVC.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 05.08.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import RxSwift

//MARK: - Subjects

class SecondModuleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        doPublishSubject()
//        doBehaviourSubject()
//        doReplaySubject()
//        doVariable()
    }
    
    
    func example(to description: String, action: ()-> Void)-> Void {
        print("----Example of: \(description)------")
        action()
    }
    
    //MARK: - Published Subject
    func doPublishSubject() {
        example(to: "PublishSubject") {
            let subject = PublishSubject<String>()
            
            subject.onNext("Is anyone listening")
            
            let subscriptionOne = subject.subscribe(onNext: { (observer) in
                print(observer)
            })
            
            subject.on(.next("1"))
            subject.on(.next("2"))
            
            let subscriptionTwo = subject.subscribe({ event in
                print("2)", event.element ?? event)
            })
            
            subject.on(.next("3 suka"))
            
            subscriptionOne.dispose()
            
            subject.on(.next("4 blet"))
            
            subject.onCompleted()
            
            subject.onNext("this is war")
            
            subscriptionTwo.dispose()
            
            let disposeBag = DisposeBag()
            
            subject.subscribe({ (event) in
                print("3)", event.element ?? event)
            }).disposed(by: disposeBag)
            
            subject.subscribe({ (event) in
                print("4)", event.element ?? event)
            }).disposed(by: disposeBag)
            
            subject.onNext("????????")
        }
    }
    
    //MARK: Behaviour Subject
    func doBehaviourSubject() {
        enum MyError: Error {
            case andreyError
        }
        
        func prints<T: CustomStringConvertible>(label: String, event: Event<T>) {
            if event.element == nil {
                print(event.error ?? "Ошибка")
            } else if event.error == nil {
                print(event.element!)
            } else {
                print(event)
            }
        }
        
        //        this subject send always initial or last event
        example(to: "Behavior Subject") {
            let subject = BehaviorSubject(value: "Initial value")
            let disposeBag = DisposeBag()
            
            subject.onNext("XXXX")
            
            subject.subscribe({
                prints(label: "1) ", event: $0)
            }).disposed(by: disposeBag)
            
            subject.onError(MyError.andreyError)
            
            subject.subscribe({
                prints(label: "2)", event: $0)
            }).disposed(by: disposeBag)
        }
    }
    
    //MARK: - Replay Subject
    func doReplaySubject() {
        
        enum MyError: Error {
            case andreyError
        }
        
        example(to: "Replat Subject") {
            let subject = ReplaySubject<String>.create(bufferSize: 2)
            let disposeBag = DisposeBag()
            
            subject.onNext("1")
            subject.onNext("2")
            subject.onNext("3")
            
            subject.subscribe({ (event) in
                print("1) \(event)")
            }).disposed(by: disposeBag)
            
            subject.subscribe({ (event) in
                print("2) \(event)")
            }).disposed(by: disposeBag)
            
            subject.onNext("4")
            
            subject.subscribe({ (event) in
                print("3) \(event)")
            }).disposed(by: disposeBag)
            
            subject.onError(MyError.andreyError)
            subject.dispose()
            
            subject.subscribe({ (event) in
                print("4) \(event)")
            }).disposed(by: disposeBag)
        }
    }
    
    func doVariable() {
        example(to: "variable") {
            let variable = Variable("Initial Value")
            let disposeBag = DisposeBag()
            
            variable.value = "Special"
            
            variable.asObservable().subscribe({ (event) in
                print("1) \(event)")
            }).disposed(by: disposeBag)
            
            variable.value = "1"
            
            variable.asObservable().subscribe({ (event) in
                print("2) \(event.element ?? "")")
            }).disposed(by: disposeBag)
            
            variable.value = "2"
        }
    }
}
