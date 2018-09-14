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

func cachedFileURL(_ filename: String) -> URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first!.appendingPathComponent(filename)
}

class FourthStartVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    private let repo = "ReactiveX/RxSwift"
    private let events = Variable<[GitEvent]>([])
    private let bag = DisposeBag()
    
    private let lastModified = Variable<NSString?>(nil)
    private let modifiedFileURL = cachedFileURL("modified.txt")
    private let eventFileURL = cachedFileURL("events.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FourthPlayGround.doThis()
        
        //write data from disk
        let eventsArray = (NSArray.init(contentsOf: eventFileURL)) as? [[String: Any]] ?? []
        lastModified.value = try? NSString(contentsOf: modifiedFileURL, usedEncoding: nil)
        
        events.value = eventsArray.flatMap(GitEvent.init)
        setUpRefreshControl()
        navigationItem.title = repo
        fetchEvents(repo: repo)
    }
    
    func fetchEvents(repo: String) {
        let response = Observable.from([repo]).map { urlString -> URL in
            return URL(string: "https://api.github.com/repos/\(urlString)/events")!
            }.map { [weak self] (url) -> URLRequest in
                var request = URLRequest(url: url)
                if let modifiedValue = self?.lastModified.value {
                    request.addValue(modifiedValue as String, forHTTPHeaderField: "Last-Modified")
                }
                return request
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
        
        response.filter { (response, _) -> Bool in
            return 200..<400 ~= response.statusCode
            }.flatMap { (response, _) -> Observable<NSString?> in
                guard let value = response.allHeaderFields["Last-Modified"] as? NSString else {
                    return Observable.empty()
                }
            return Observable.just(value)
            }.subscribe(onNext: { [weak self] modifiedHeader in
                guard let strongSelf = self else { return }
                strongSelf.lastModified.value = modifiedHeader
                try? modifiedHeader?.write(to: strongSelf.modifiedFileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
            }).disposed(by: bag)
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
        self.refreshControl.endRefreshing()
        let eventsArray = updateEvents.map({ $0.dictionary }) as NSArray
        eventsArray.write(to: eventFileURL, atomically: true)
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

extension FourthStartVC {
    func setUpRefreshControl() {
        refreshControl.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        DispatchQueue.global(qos: .background).async {
            self.fetchEvents(repo: self.repo)
        }
    }
}
