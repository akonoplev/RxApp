//
//  FifthStartVC.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 18.09.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import RxSwift

class FifthStartVC: UITableViewController {

    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    let disposeBag = DisposeBag()
    var dataSource = Variable<[EOCategory]>([])

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpActivityIndicator()
        startDownload()
        dataSource.asObservable().subscribe(onNext: { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        self.tableView.tableFooterView = UIView()
    }
}

extension FifthStartVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = dataSource.value[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(category.name) (\(category.events.count))"
        cell.accessoryType = category.events.count > 0 ? .disclosureIndicator : .none
        cell.detailTextLabel?.text = category.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.dataSource.value[indexPath.row]
        if !category.events.isEmpty {
            //let storyboard = UIStoryboard(name: "Fifth", bundle: nil)
            let eventController = storyboard!.instantiateViewController(withIdentifier: "eventsViewController") as! EventsViewController
            eventController.title = category.name
            eventController.dataSource.value = category.events
            navigationController!.pushViewController(eventController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FifthStartVC {
    func startDownload() {
        self.activityIndicator.startAnimating()
        let eoCategories = EONET.category
        let downloadEvents = eoCategories.flatMap({ categories in
            return Observable.from(categories).map({ (category) in
                EONET.events(forLast: 360, category: category)
            })
        }).merge(maxConcurrent: 2)
        
        let updateCategories = eoCategories.flatMap({ categories in
            downloadEvents.scan(categories) { updated, events in
                return updated.map({ category  in
                    let eventsForCategory = EONET.filteredEvents(events: events, forCategory: category)
                    if !eventsForCategory.isEmpty {
                        var cat = category
                        cat.events = cat.events + eventsForCategory
                        return cat
                    }
                    return category
                })
            }
            
        })
        
        updateCategories.subscribe {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }

        }.disposed(by: disposeBag)
        
        eoCategories.concat(updateCategories)
            .bind(to: dataSource).disposed(by: disposeBag)
    }
}

extension FifthStartVC {
    func setUpActivityIndicator() {
        self.activityIndicator.activityIndicatorViewStyle = .white
        self.activityIndicator.isHidden = false
        self.activityIndicator.clipsToBounds = false
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: false)
        self.navigationItem.rightBarButtonItem?.customView = self.activityIndicator
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
    }
}
