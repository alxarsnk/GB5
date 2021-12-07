//
//  ListViewController.swift
//  HWExample
//
//  Created by Александр Арсенюк on 30.11.2021.
//

import Foundation
import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    @IBOutlet weak var datalabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let realmManager = RealmManager()
    
    var totalCount: Int = 0
    var totalLoaded: Int = 0
    var isLoading: Bool = false
    

    var token: NotificationToken?
    var dataSource: Results<Friend>?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        mathcRealm()
    }
    
    func mathcRealm() {
        let realm = try! Realm()
        dataSource = realm.objects(Friend.self)
        token = dataSource?.observe { [weak self] changes in
            switch changes {
            case let .update(results, deletions, insertions, modifications):
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .fade)
                self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .fade)
                self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .fade)
                self?.tableView.endUpdates()
                print("UPDATED")
                
                print(self?.dataSource?.count)
            case .initial:
                self?.tableView.reloadData()
                print("INTITAL")
            case .error(let error):
                print("Error")
                
            }
        }
    }
    
    @IBAction func addFirend(_ sender: Any) {
        makeFriendsRequest()
//        let realm = try! Realm()
//        realm.beginWrite()
//        let friend = Friend()
//        friend.firstName = "NEW FRIEND 2"
//        friend.lastName = "Last"
//        friend.domain = ""
//        friend.trackCode = ""
//        realm.add(friend)
//        try! realm.commitWrite()
    }
    
    
    func makeFriendsRequest() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "city,domain,sex,bdate"),
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            do {
                let fetchedResponse = try JSONDecoder().decode(VKFriendResponse.self, from: data!)
                let frineds = fetchedResponse.response?.items
                
                let string = frineds?.first?.lastName
                self?.realmManager.save(data: Array(frineds!))
            } catch {
                print(error)
            }
        }.resume()
    }
    
}


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let friend = dataSource?[indexPath.row]
        cell?.textLabel?.text = friend?.firstName ?? "" + " " + friend!.lastName
        return cell ?? UITableViewCell()
    }
    
    
}
