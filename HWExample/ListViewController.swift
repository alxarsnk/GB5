//
//  ListViewController.swift
//  HWExample
//
//  Created by Александр Арсенюк on 30.11.2021.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var datalabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var totalCount: Int = 0
    var totalLoaded: Int = 0
    var isLoading: Bool = false
    
    var dataSource: [Friend] = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        makeFriendsRequest(isInitial: true, from: totalLoaded, count: 20)
        
    }
    
    func makeFriendsRequest(isInitial: Bool, from: Int, count: Int) {
        isLoading = true
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "city,domain,sex,bdate"),
            URLQueryItem(name: "v", value: "5.131"),
//            URLQueryItem(name: "offset", value: "\(from)"),
//            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "access_token", value: Session.shared.token),
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            do {
                let fetchedResponse = try JSONDecoder().decode(VKFriendResponse.self, from: data!)
                let frineds = fetchedResponse.response?.items
                
                
                let string = frineds?.first?.lastName
            
//                if isInitial {
//                    self?.totalCount = fetchedResponse.response.count
                    self?.dataSource = Array(frineds!)
//                } else {
//                    self?.dataSource.append(contentsOf: frineds)
//                }
               
//                self?.totalLoaded += frineds.count
                
                DispatchQueue.main.async {
                    self?.datalabel.text = string
                    self?.tableView.reloadData()
                }
                
                self?.isLoading = false
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
}


extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let friend = dataSource[indexPath.row]
        cell?.textLabel?.text = friend.firstName + " " + friend.lastName
        return cell ?? UITableViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("End Dragging")
//        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) && !isLoading && totalLoaded != totalCount {
//            print("Start")
//            makeFriendsRequest(isInitial: false, from: totalLoaded, count: 20)
//        }
    }
    
    
}
