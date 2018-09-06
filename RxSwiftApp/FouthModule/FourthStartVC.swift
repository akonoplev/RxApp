//
//  FouthStartVC.swift
//  RxSwiftApp
//
//  Created by Андрей Коноплев on 24.08.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class FourthStartVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let repo = "ReactiveX/RxSwift"
    private let events = Variable<[GitEvent]>([])
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FourthPlayGround.doThis()
        navigationItem.title = repo
        let response = Observable.from([repo]).map { urlString -> URL in
            return URL(string: "https://api.github.com/repos/\(urlString)/events")!
            }.map { (url) -> URLRequest in
                return URLRequest(url: url)
            }.flatMap { (request) -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
        }.share(replay: 1, scope: .whileConnected)
        
        response.filter { (response, _) -> Bool in
            return 200..<300 ~= response.statusCode
            }.map { (_ , data) -> [[String: Any]] in
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let result = jsonObject as? [[String: Any]] else { return [] }
                return result
            }.filter { (objects) -> Bool in
                return objects.count > 0
            }.map { objects in
                objects.flatMap(GitEvent.init)
            }.subscribe(onNext: { [weak self] newEvents in
                DispatchQueue.main.async {
                    self?.processEvents(newEvents)
                }

            })
            .disposed(by: bag)
    }
}

extension FourthStartVC {
    func processEvents(_ newEvents: [GitEvent]) {
        var updateEvents = newEvents + events.value
        if updateEvents.count > 50 {
            updateEvents = Array<GitEvent>(updateEvents.prefix(upTo: 50))
        }
        events.value = updateEvents
        self.tableView.reloadData()
    }
}

extension FourthStartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let event = events.value[indexPath.row]
        let textLabel = cell.viewWithTag(1) as! UILabel
        textLabel.text = event.repo
        let detailText = cell.viewWithTag(2) as! UILabel
        detailText.text = event.repo + ", " + event.action.replacingOccurrences(of: "GitEvent", with: "").lowercased()
        
        let imageView = cell.viewWithTag(3) as! UIImageView
        imageView.kf.setImage(with: event.imageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
