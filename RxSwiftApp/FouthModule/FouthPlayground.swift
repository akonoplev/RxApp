//
//  FouthPlayground.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 24.08.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import RxSwift

class FourthPlayGround {

    class func doThis() {
        example(of: "ignoreElement") {
            let strike = PublishSubject<String>()
            let bag = DisposeBag()
            
            strike.ignoreElements().subscribe { _ in
                print("You are out")
            }.disposed(by: bag)
            
            strike.onNext("XXX")
            strike.onNext("XXX")
            strike.onCompleted()
        }
        
        example(of: "elementAt") {
            let bag = DisposeBag()
            let strike = PublishSubject<String>()
            
            strike.elementAt(1).subscribe({ element in
                print("Это второй элемент  \(element)")
            }).disposed(by: bag)
            
            strike.onNext("Андрей")
            strike.onNext("Николаевич")
            strike.onNext("Коноплев")
            strike.onNext("о")
        }
        
        example(of: "filter") {
            let bag = DisposeBag()
            //let array = [12,3,23,2,1,65,34,1009]
            
            Observable.of(12,3,23,2,1,65,34,1009).filter{ integer in
                integer < 100
                }.subscribe(onNext: {
                    print($0)
                }).disposed(by: bag)
        }
        
        example(of: "Skip") {
            let bag = DisposeBag()
            
            Observable.of("A", "B", "C", "D", "E").skip(2).subscribe(onNext: {
                print($0)
            }).disposed(by: bag)
        }
        
        example(of: "skipWhile") {
            
            let disposeBag = DisposeBag()
            
            Observable.of(2, 2, 3, 4, 5)

                .skipWhile { integer in
                    integer % 2 == 0
                }
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            }
        
        example(of: "skipUntil") {
            let bag = DisposeBag()
            
            let subject = PublishSubject<String>()
            let trigger = PublishSubject<String>()
            
            subject.skipUntil(trigger).subscribe(onNext: {
                print($0)
            }).disposed(by: bag)
            
            subject.onNext("A")
            subject.onNext("B")
            trigger.onNext("start")
            subject.onNext("C")
        }
        
        example(of: "take") {
            let bag = DisposeBag()
            
            Observable.of(1,2,3,4,5,6).take(5).subscribe(onNext: {
                print($0)
            }).disposed(by: bag)
        }
        
        example(of: "takeWhile") {
            let bag = DisposeBag()
            
            Observable.of(2,2,4,4,6,6).enumerated().takeWhile { index, integer in
                integer % 2 == 0 && index < 3
                }.map { $0.element}.subscribe(onNext: {
                    print($0)
                }).disposed(by: bag)
        }
        
        example(of: "takeUntil") {
            let bag = DisposeBag()
            
            let subject = PublishSubject<String>()
            let trigger = PublishSubject<String>()
            
            subject.takeUntil(trigger).subscribe(onNext: {
                print($0)
            }).disposed(by: bag)
            
            subject.onNext("A")
            subject.onNext("B")
            trigger.onNext("C")
            subject.onNext("X")
        }
        
        example(of: "distinctUntilChanged") {
            let bag = DisposeBag()
            
            Observable.of("A", "A", "B", "B", "A").distinctUntilChanged().subscribe(onNext: {
                print($0)
            }).disposed(by: bag)
        }
        
        example(of: "distinctUntilChange(: _)") {
            let bag = DisposeBag()
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            
            Observable<NSNumber>.of(10, 110, 20, 220, 210, 310).distinctUntilChanged { a, b in
                guard let aWords = formatter.string(from: a)?.components(separatedBy: " "),
                    let bWords = formatter.string(from: b)?.components(separatedBy: " ") else { return false }
                var containsMatch = false
                
                for aWord in aWords {
                    for bWord in bWords {
                        if aWord == bWord {
                            containsMatch = true
                            break
                        }
                    }
                }
                return containsMatch
                }.subscribe(onNext: {
                    print($0)
                }).disposed(by: bag)
        }
        
        example(of: "filter phone number") {
            
            let disposeBag = DisposeBag()
            
            let contacts = [
                "603-555-1212": "Florent",
                "212-555-1212": "Junior",
                "408-555-1212": "Marin",
                "617-555-1212": "Scott"
            ]
            
            func phoneNumber(from inputs: [Int]) -> String {
                var phone = inputs.map(String.init).joined()
                
                phone.insert("-", at: phone.index(
                    phone.startIndex,
                    offsetBy: 3)
                )
                
                phone.insert("-", at: phone.index(
                    phone.startIndex,
                    offsetBy: 7)
                )
                
                return phone
            }
            
            let input = PublishSubject<Int>()
            
            
            input
                .skipWhile({ $0 == 0 })
                .filter({ $0 < 10 })
                .take(10)
                .toArray().subscribe(onNext: {
                    print("onNext : \($0)")
                    let phone = phoneNumber(from: $0)
                    if let name = contacts[phone] {
                        print("Найден контак \(name) - \(phone)")
                    } else {
                        print("Контакт не найден")
                    }
                }).disposed(by: disposeBag)
            

            input.onNext(0)
            input.onNext(603)
            
            input.onNext(2)
            input.onNext(1)
            input.onNext(2)
            
            "5551212".forEach {
                if let number = (Int("\($0)")) {
                    input.onNext(number)
                }
            }
            input.onNext(9)
        }
        
        
        //MARK: - FILTERS
    }
    
    class func example(of: String, success: ()-> Void) {
        print("======\(of)======")
        success()
    }
}
