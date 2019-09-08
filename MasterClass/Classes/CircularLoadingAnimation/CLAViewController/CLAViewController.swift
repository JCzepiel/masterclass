//
//  ViewController.swift
//  CircularLoadingTutorial
//
//  Created by Stephen Bodnar on 8/6/18.
//  Copyright © 2018 Stephen Bodnar. All rights reserved.
//

import UIKit

class CLAViewController: UIViewController {
    var tableView = UITableView()
    var photoUrls = ["https://pbs.twimg.com/media/D1qL2thX4AEon4f.jpg:large",  "https://pbs.twimg.com/media/D1RKGQkWoAAFv6a.jpg:large",  "https://pbs.twimg.com/media/D0tYw_5XcAEhPwx.jpg:large", "https://pbs.twimg.com/media/DsstaR0VsAAV_pF.jpg:large",  "https://pbs.twimg.com/media/DspDFxJUUAA1xrw.jpg:large"]
    
    var imageDownloader = CLAImageDownloader()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        layout()
        
        imageDownloader.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
}

extension CLAViewController {
    func layout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CLAImageCell.self, forCellReuseIdentifier: "ImageCell")
    }
}

extension CLAViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
}

extension CLAViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as? CLAImageCell {
            cell.configure(with: imageDownloader, andUrl: photoUrls[indexPath.row], forIndexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
}



