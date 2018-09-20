//
//  EventsViewController.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 19.09.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var daysLabel: UILabel!
    
    let disposeBag = DisposeBag()
    let dataSource = Variable<[EOEvent]>([])
    
    let days = Variable<Int>(360)
    let filtredEvents = Variable<[EOEvent]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        filtredEvents.asObservable().subscribe(onNext: { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(days.asObservable(), dataSource.asObservable()) { (days, events)-> [EOEvent] in
            let maximumInterval = TimeInterval(days * 24 * 3600)
            return events.filter({ event in
                if let date = event.closeDate {
                    return abs(date.timeIntervalSinceNow) < maximumInterval
                }
                return true
            })
        }.bind(to: filtredEvents).disposed(by: disposeBag)
        
        days.asObservable().subscribe(onNext: { [weak self] days in
            self?.daysLabel.text = "Last \(days) days"
        }).disposed(by: disposeBag)
        
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredEvents.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTVCell
        let event = filtredEvents.value[indexPath.row]
        cell.configure(event: event)
        return cell
    }
    
}

extension EventsViewController {
    @IBAction func sliderAction(_ sender: Any) {
        days.value = Int(self.slider.value)
    }
}
