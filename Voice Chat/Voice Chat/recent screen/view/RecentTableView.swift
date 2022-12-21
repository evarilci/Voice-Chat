//
//  RecentTableView.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 21.12.2022.
//

import UIKit

final class RecentTableView: UIView {

    
     var tableView = UITableView()
     
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         setTableViewConstraints()
         tableView.register(RecentCell.self, forCellReuseIdentifier: "recentCell")
         tableView.rowHeight = 100
         
         
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     func setTableViewDelegates(delegate Delegate: UITableViewDelegate, datasource DataSource: UITableViewDataSource) {
         
         tableView.delegate = Delegate
         tableView.dataSource = DataSource
     }
     
     func setTableViewConstraints() {
         addSubview(tableView)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
         ])
     }


}
