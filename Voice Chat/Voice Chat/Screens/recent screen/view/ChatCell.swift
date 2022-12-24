//
//  ChatCell.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 21.12.2022.
//

import UIKit

final class ChatCell: UITableViewCell {
    
    var action : (() -> Void)? = nil
    
    @objc func messagePlayer(sender: UIButton) {
        action?()
    }

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textColor = UIColor.systemMint
        return label
    }()
    
     var motherView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
        
    }()
    
     var meSender : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        return imageView
    }()
    
     var youSender : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()
    
    let playButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Record"), for: .normal)
        button.tintColor = UIColor.systemIndigo
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
   
    
    var username : String? {
        set {
            nameLabel.text = newValue!
        }
        get {
            nameLabel.text
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        playButton.addTarget(self, action: #selector(messagePlayer(sender:)), for: .touchUpInside)
        configureLabel()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLabel() {
        
       
        
        addSubview(meSender)
        meSender.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            meSender.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            meSender.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            meSender.heightAnchor.constraint(equalToConstant: 40),
            meSender.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        
        
        addSubview(youSender)
        youSender.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            youSender.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            youSender.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            youSender.heightAnchor.constraint(equalToConstant: 40),
            youSender.widthAnchor.constraint(equalToConstant: 40)
        ])
    
        addSubview(motherView)
        motherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            motherView.leadingAnchor.constraint(equalTo: youSender.trailingAnchor, constant: 8),
            motherView.trailingAnchor.constraint(equalTo: meSender.leadingAnchor, constant: -8),
            motherView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            motherView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        contentView.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: motherView.centerYAnchor),
           // playButton.leadingAnchor.constraint(equalTo: motherView.leadingAnchor, constant: 4),
            playButton.trailingAnchor.constraint(equalTo: motherView.trailingAnchor, constant: -4),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor)
          

        ])
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //nameLabel.leadingAnchor.constraint(equalTo: motherView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: motherView.topAnchor, constant: 4),
            nameLabel.heightAnchor.constraint(equalToConstant: 17)
            
        ])
        
        
    }

}
