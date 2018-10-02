import UIKit
import RxSwift
import RxCocoa
//MARK: - Timing operators RxSwift

let elementsPerSecond = 1
let maxElements = 5
let replayElement = 1
let replayDeley: TimeInterval = 3

let sourceObservable = Observable<Int>.create { (observer)  in
    var value = 1
    let timerFlag = DispatchSource.TimerFlags(rawValue: UInt( 1.0 / Double(elementsPerSecond)))
    let timer = DispatchSource.makeTimerSource(flags: timerFlag, queue: .main)
    
    if value <= maxElements {
    observer.onNext(value)
        value += 1
    }
    
    return Disposables.create {
        timer.suspend()
    }
    
    }.replay(replayElement)

DispatchQueue.main.asyncAfter(deadline: .now() + replayDeley) {
    sourceObservable.subscribe(onNext: { int in
        print(int)
    })
}


_ = sourceObservable.connect()


