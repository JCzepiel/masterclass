//
//  RetainCycleInstruments.swift
//  RetainCycleInstruments
//
//  Created by James Czepiel on 1/7/19.
//  Copyright © 2019 James Czepiel. All rights reserved.
//

import UIKit

class RetainCycleInstrumentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Red", style: .plain, target: self, action: #selector(showRed))
    }
    
    @objc func showRed() {
        let redController = RetainCycleInstrumentsRedController()
        navigationController?.pushViewController(redController, animated: true)
    }
}

class RetainCycleInstrumentsService {
    static let shared = RetainCycleInstrumentsService()
    
    func fetchData(completion: @escaping (Error?) -> ()) {
        guard let url = URL(string: "https://www.google.com") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(error)
        }
    }
}

class RetainCycleInstrumentsRedController: UIViewController {
    
    deinit {
        print("OS is reclaiming memory from RedController!!")
    }
    
    var refreshTableviewClosure: ((Data?, Error) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        RetainCycleInstrumentsService.shared.fetchData { [weak self] (error) in
            if let _ = error {
                return
            }
            
            self?.showAlert()
        }
        
        refreshTableviewClosure = { [weak self] data, error in
            self?.showAlert()
        }

        //Add this line back to witness a retain cycle!!! This line causes RedController to stay in memory because we use unowned self instead of weak self
//        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "someName"), object: nil, queue: .main) { [unowned self] (notification) in
//            self.showAlert()
//        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Red Alert", message: "I am a red alert inside Red Controller", preferredStyle: .alert)
        present(alert, animated: true)
    }
}

