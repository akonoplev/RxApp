//
//  FouthPlayground.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 24.08.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation
import RxSwift

// RXSwift OPERATORS

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
        
        
        //MARK: - Transforming operators
        example(of: "toArray") {
            let disposeBag = DisposeBag()
            Observable.of("A", "B", "C")
                .toArray()
                .subscribe(onNext: {
                    print($0)
                }).disposed(by: disposeBag)
        }
        
        example(of: "map") {
            let bag = DisposeBag()
            
            Observable.of(1,2,3).map({
                $0 * 2
            }).subscribe(onNext: {
                print($0)
            }).disposed(by: bag)
        }
        
        example(of: "one more map") {
            let bag = DisposeBag()
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            
            Observable<NSNumber>.of(123, 55, 16)
                .map {
                    formatter.string(from: $0) ?? ""
                }.subscribe(onNext: {
                    print($0)
                }).disposed(by: bag)
        }
        
        example(of: "enumerationg and map") {
            let bag = DisposeBag()
            
            Observable.of(1,2,3,4,5,6)
                .enumerated()
                .map({ index, integer in
                    index > 2 ? integer * 2 : integer
                }).subscribe(onNext: {
                    print($0)
                }).disposed(by: bag)
        }
        
        struct Student {
            var score: BehaviorSubject<Int>
            
        }
        
        example(of: "flat map") {
            
            let bag = DisposeBag()
            
            let andrey = Student(score: BehaviorSubject(value: 80))
            let alexey = Student(score: BehaviorSubject(value: 90))
            
            let student = PublishSubject<Student>()
            
            student.flatMap {
                $0.score
                }.subscribe(onNext: {
                print($0)
            }).disposed(by: bag)
            
            student.onNext(andrey)
            andrey.score.onNext(99)
            student.onNext(alexey)
            alexey.score.onNext(88)
        }
        
        example(of: "flatMapLates") {
            let disposeBag = DisposeBag()
            
            let andrey = Student(score: BehaviorSubject(value: 80))
            let alexey = Student(score: BehaviorSubject(value: 90))
            
            let student = PublishSubject<Student>()
            
            student.flatMapLatest {
                $0.score
                }.subscribe(onNext: {
                    print($0)
                }).disposed(by: disposeBag)
            
            student.onNext(andrey)
            andrey.score.onNext(14)
            student.onNext(alexey)
            andrey.score.onNext(15)
            // dont print becouse switch to alexey
            alexey.score.onNext(16)
        }
        
        example(of: "materialize and dematerialize") {
            enum myError: Error {
                case anError
            }
            
            let bag = DisposeBag()
            
            let andrey = Student(score: BehaviorSubject(value: 80))
            let alexey = Student(score: BehaviorSubject(value: 90))
            
            let student = BehaviorSubject(value: andrey)
            
            let studentScore = student.flatMapLatest {
                $0.score.materialize()
            }
            
            studentScore.filter {
                guard $0.error == nil else {
                    print($0.error!)
                    return false
                }
                return true
                }.dematerialize()
                .subscribe(onNext: {
                print($0)
            }).disposed(by: bag)
            
            andrey.score.onNext(134)
            andrey.score.onError(myError.anError)
            andrey.score.onNext(154)
            
            student.onNext(alexey)
        }
        
        //MARK: - Combining Operators
        example(of: "startWith") {
            let bag = DisposeBag()
            
            let numbers = Observable.of(2,3,4)
            let observable = numbers.startWith(1)
            observable.subscribe(onNext: { value in
                print(value)
            }).disposed(by: bag)
        }
        
        example(of: "concat") {
            let bag = DisposeBag()
            
            let arr1 = Observable.of(1,2,3)
            let arr2 = Observable.of(4,5,6)
            
            let arr = Observable.concat([arr1, arr2])
            
            //or
//            let arr = arr1.concat(arr2)
            
            arr.subscribe(onNext: { value in
                print(value)
            }).disposed(by: bag)
        }
        
        example(of: "concatMap") {
            let bag = DisposeBag()
            
            let sequences = ["Germany": Observable.of("Berlin", "Frankfurt", "Duseldorf"),
                             "Spain": Observable.of("Barca" , "Madrid", "Valencia")]
            let observable = Observable.of("Germany", "Spain").concatMap({ country in
                sequences[country] ?? .empty()
            })
            
            observable.subscribe(onNext: { string in
                print(string)
            }).disposed(by: bag)
        }
        
        example(of: "merge") {
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            
            let source = Observable.of(left.asObservable(), right.asObservable())
            let observable = source.merge()
            
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            
            var leftValue = ["Berlin", "Frankfurt", "Duseldorf"]
            var rightValue = ["Barca" , "Madrid", "Valencia"]
            
            repeat {
                if arc4random_uniform(2) == 0 {
                    if !leftValue.isEmpty {
                        left.onNext("left: " + leftValue.removeFirst())
                    }
                } else if !rightValue.isEmpty {
                    right.onNext("right: " + rightValue.removeFirst())
                }
            } while !leftValue.isEmpty || !rightValue.isEmpty
            disposable.dispose()
        }
        
        example(of: "combineLatest") {
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            
            let observable = Observable.combineLatest(left, right, resultSelector: { leftValue, rightValue in
                leftValue + " " + rightValue
            })
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            
            left.onNext("Hello, ")
            right.onNext("World")
            right.onNext("Have a nice day")
            left.onNext("RxSwift")
            disposable.dispose()
        }
        
        example(of: "combine user choice and value") {
            let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
            let dates = Observable.of(Date())
            
            let observable = Observable.combineLatest(choice, dates) { (format, when) -> String in
                let formatter = DateFormatter()
                formatter.dateStyle = format
                return formatter.string(from: when)
            }
            
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            
            disposable.dispose()
        }
        
        // wait befor both sequence emit
        example(of: "zip") {
            enum Weather {
                case sunny
                case cloudly
            }
            
            let left: Observable<Weather> = Observable.of(.sunny, .cloudly, .sunny, .cloudly, .sunny)
            let right = Observable.of("Lisabon", "Moscow", "Madrid", "Sochi", "Barca")
            
            let observable = Observable.zip(left, right) { whether, city  in
                return "It`s \(whether) in \(city)"
            }
            
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            
            disposable.dispose()
        }
     
        example(of: "withLatesFrom") {
            let button = PublishSubject<Void>()
            let textField = PublishSubject<String>()
            
            let observable = button.withLatestFrom(textField)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
            
            textField.onNext("Par")
            textField.onNext("Pari")
            textField.onNext("Paris")
            button.onNext(())
            button.onNext(())
        }
        
        example(of: "sample") {
            let button = PublishSubject<Void>()
            let textField = PublishSubject<String>()
            
            let observable = textField.sample(button)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
            
            textField.onNext("Par")
            textField.onNext("Pari")
            textField.onNext("Paris")
            button.onNext(())
            button.onNext(())
            textField.onNext("Paris my")
            button.onNext(())
        }
        
        example(of: "amb") {
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            
            let observable = left.amb(right)
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            
            left.onNext("Lisabon")
            right.onNext("Moscow")
            left.onNext("Vienna")
            left.onNext("Rome")
            right.onNext("Paris")
            
            disposable.dispose()
        }
        
        example(of: "switchLatest") {
            let one = PublishSubject<String>()
            let two = PublishSubject<String>()
            let three = PublishSubject<String>()
            
            let source = PublishSubject<Observable<String>>()
            
            let observable = source.switchLatest()
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            
            source.onNext(one)
            one.onNext("Some text from one")
            two.onNext("Some text from two")
            
            source.onNext(two)
            two.onNext("more text from two")
            one.onNext("more text from one")
            
            source.onNext(three)
            two.onNext("one more text from two")
            one.onNext("one more text from one")
            three.onNext("some text from sequence three")
            
            source.onNext(one)
            one.onNext("One one one one")
            disposable.dispose()
        }
        
        example(of: "reduce") {
            let source = Observable.of(1,3,5,7,9)
            
            let observable = source.reduce(0, accumulator: +)
            observable.subscribe(onNext: { value in
                print(value)
            }).disposed(by: DisposeBag())
            
            let obserable1 = source.reduce(0, accumulator: { summary, newValue in                return summary + newValue
            })
            
            obserable1.subscribe(onNext: { value in
                print(value)
            }).disposed(by: DisposeBag())
        }
        
        example(of: "scan") {
            let scanInfo = Observable.of(1, 3, 5, 7, 9, 11)
            let observable = scanInfo.scan(0, accumulator: +)
            observable.subscribe(onNext: { value in
                print(value)
            }).disposed(by: DisposeBag())
        }
        
        example(of: "Challenge 9") {
            
            let bag = DisposeBag()
            let array = Observable.of(1, 3, 5, 6, 8, 12)
            
            let left = PublishSubject<Int>()
            let right = PublishSubject<Int>()
            
            let observable = Observable.zip(left, right)
            _ = observable.subscribe(onNext: { a, b in
                print("total: \(a) and number \(b)")
            }).disposed(by: bag)
            
            let obserable1 = array.scan(0, accumulator: { summary, newValue in
                left.onNext(summary)
                right.onNext(newValue)
                return summary + newValue
            })
            
            _ = obserable1.subscribe(onNext: { value in
                
            })
            

        }
    }
    
    
    
    class func example(of: String, success: ()-> Void) {
        print("======\(of)======")
        success()
    }
}
