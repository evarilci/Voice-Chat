//
//  ChatCell.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 21.12.2022.
//

import UIKit

final class ChatCell: UITableViewCell {

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        return label
    }()
    
    private var motherView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
        
    }()
    
    private var iconImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        return imageView
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
        
        configureLabel()
        motherView.cornerRadius = nameLabel.frame.height / 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLabel() {
        
       
        
        addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            iconImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            iconImage.heightAnchor.constraint(equalToConstant: 40),
            iconImage.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        addSubview(motherView)
        motherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            motherView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            motherView.trailingAnchor.constraint(equalTo: iconImage.leadingAnchor, constant: -8),
            motherView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            motherView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: motherView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: motherView.trailingAnchor, constant: -4),
            nameLabel.topAnchor.constraint(equalTo: motherView.topAnchor, constant: 4),
            nameLabel.bottomAnchor.constraint(equalTo: motherView.bottomAnchor, constant: -4)
            
        ])
        
        
    }

}
