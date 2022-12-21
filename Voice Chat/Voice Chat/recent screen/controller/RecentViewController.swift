//
//  RecentViewController.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 21.12.2022.
//

import UIKit

final class RecentViewController: UIViewController {
    
    let mainView = RecentTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        view = mainView
        mainView.setTableViewDelegates(delegate: self, datasource: self)
    }
}


extension RecentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath) as! RecentCell
        cell.username = "eymen varilci"
        return cell
    }
    
    
}
