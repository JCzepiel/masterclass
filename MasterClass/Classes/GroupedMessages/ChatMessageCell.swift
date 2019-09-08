//
//  ChatMessageCell.swift
//  GroupedMessagesLBTA
//
//  Created by James Czepiel on 12/13/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {

    let messageLabel = UILabel()
    
    let bubbleBackgroundView = UIView()
    
    var chatMessage: ChatMessage? {
        didSet {
            guard let message = chatMessage else { return }
            bubbleBackgroundView.backgroundColor = message.isIncoming ? .white : .darkGray
            messageLabel.textColor = message.isIncoming ? .black : .white
            messageLabel.text = message.text
            
            if message.isIncoming {
                trailingConstraint?.isActive = false
                leadingConstraint?.isActive = true
            } else {
                leadingConstraint?.isActive = false
                trailingConstraint?.isActive = true
            }
        }
        
    }
    
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = .white
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = 12
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0

        let constraints = [
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
        messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
        
        bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
        bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
        bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)

        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
