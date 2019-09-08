//
//  AutoTextViewSizingViewControllerswift
//  AutoTextViewSizingLBTA
//
//  Created by James Czepiel on 12/10/18.
//  Copyright © 2018 James Czepiel. All rights reserved.
//

import UIKit

class AutoTextViewSizingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        textView.backgroundColor = .lightGray

        //textView.text = "2018-12-10 08:53:14.951506-0500 AutoTextViewSizingLBTA[73279:1357138] [MC] System group container for systemgroup.com.apple.configurationprofiles path is /Users/00915073/Library/Developer/CoreSimulator/Devices/558CEADA-F773-42BC-A071-9FAB30F76322/data/Containers/Shared/SystemGroup/systemgroup.com.apple.configurationprofiles"
        
        view.addSubview(textView)

        textView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 50)
        ].forEach { $0.isActive = true }
        
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        
        textView.delegate = self
        textView.isScrollEnabled = false
        
        textViewDidChange(textView)
    }
}

extension AutoTextViewSizingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
