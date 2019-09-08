//
//  GroupedMessagesViewController.swift
//  GroupedMessagesLBTA
//
//  Created by James Czepiel on 12/13/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

struct ChatMessage {
    let text: String
    let isIncoming: Bool
    let date: Date
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

class GroupedMessagesViewController: UITableViewController {
    
    let cellId = "id"
    
    let messagesFromServer = [
        ChatMessage(text: "Lorem ipsum dolor sit amet.", isIncoming: true, date: Date.dateFromCustomString(customString: "12/01/2018")),
        ChatMessage(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", isIncoming: true, date: Date.dateFromCustomString(customString: "12/01/2018")),
        ChatMessage(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", isIncoming: false, date: Date.dateFromCustomString(customString: "12/03/2018")),
        ChatMessage(text: "Lorem ipsum.", isIncoming: false, date: Date.dateFromCustomString(customString: "12/03/2018")),
        ChatMessage(text: "Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.", isIncoming: true, date: Date.dateFromCustomString(customString: "12/03/2018")),
        ChatMessage(text: "Nunc viverra diam vitae lacus tempus, at faucibus turpis rutrum. Sed id justo quis libero aliquet molestie vel a ante. Fusce convallis sit amet risus nec placerat. Mauris aliquam, justo non venenatis ultricies, lorem sem rhoncus sem, eu porttitor ante lacus et nibh. Lorem ipsum dolor sit amet, consectetur adipiscing elit.", isIncoming: true, date: Date.dateFromCustomString(customString: "12/04/2018"))
    ]
    
    var chatMessages = [[ChatMessage]]()
    
    fileprivate func attemptToAssembleGroupedMessages() {
        let groupedMessages = Dictionary(grouping: messagesFromServer) { (message) -> Date in
            return message.date
        }
        
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            chatMessages.append(values ?? [])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attemptToAssembleGroupedMessages()

        navigationItem.title = "Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: cellId)
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return chatMessages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    class DateHeaderLabel: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1.0)
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 16
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 20, height: height)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let firstMessageInSection = chatMessages[section].first else { return UIView() }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: firstMessageInSection.date)
        
        let label = DateHeaderLabel()
        label.text = dateString
        
        let containerView = UIView()
        containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let chatMessage = chatMessages[indexPath.section][indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }
}

