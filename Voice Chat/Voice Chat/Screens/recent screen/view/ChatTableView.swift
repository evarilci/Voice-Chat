//
//  ChatTableView.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 21.12.2022.
//

import UIKit

final class ChatTableView: UIView {

    
    let tableView = UITableView()
    let messageLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemIndigo
        return view
    }()
    let micButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Record"), for: .normal)
        return button
    }()
     
    let playButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.3.fill"), for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
     
     override init(frame: CGRect) {
         super.init(frame: frame)
         setTableViewConstraints()
         tableView.register(ChatCell.self, forCellReuseIdentifier: K.cellName)
         tableView.separatorStyle = .none
         
         
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     func setTableViewDelegates(delegate Delegate: UITableViewDelegate, datasource DataSource: UITableViewDataSource) {
         
         tableView.delegate = Delegate
         tableView.dataSource = DataSource
         
     }
     
     func setTableViewConstraints() {
         addSubview(messageLine)
         messageLine.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            messageLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            messageLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            messageLine.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            messageLine.heightAnchor.constraint(equalToConstant: 100)
         
         ])
         
         addSubview(micButton)
         micButton.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            micButton.centerXAnchor.constraint(equalTo: messageLine.centerXAnchor),
            micButton.centerYAnchor.constraint(equalTo: messageLine.centerYAnchor),
            micButton.heightAnchor.constraint(equalTo: messageLine.heightAnchor,constant: -32),
            micButton.widthAnchor.constraint(equalTo: micButton.heightAnchor)
         ])
         
         addSubview(playButton)
         playButton.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: micButton.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: micButton.leadingAnchor, constant: -32),
            playButton.widthAnchor.constraint(equalTo: micButton.widthAnchor, multiplier: 1 / 2),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor)

         ])

         addSubview(sendButton)
         sendButton.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            sendButton.centerYAnchor.constraint(equalTo: micButton.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: messageLine.trailingAnchor,constant: -16),
            sendButton.widthAnchor.constraint(equalTo: playButton.widthAnchor),
            sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor)

         ])
         
         addSubview(tableView)
         tableView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageLine.topAnchor)
         ])
     }


}
