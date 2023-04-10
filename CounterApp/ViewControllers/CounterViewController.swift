//
//  CounterViewController.swift
//  CounterApp
//
//  Created by Pavel on 6.04.23.
//

import UIKit

enum UpdateType {
    case plus
    case minus
}

class CounterViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    var counter: CounterModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = counter?.title
        countLabel.text = "\(counter?.count ?? 0)"
    }
    
    @IBAction func plusButtonPressed(_ sender: CountButton) {
        updateCount(type: .plus)
        countLabel.text = "\(counter?.count ?? 0)"
    }
    
    @IBAction func minusButtonPressed(_ sender: CountButton) {
        if counter!.count > 0 {
            updateCount(type: .minus)
            countLabel.text = "\(counter?.count ?? 0)"
        }
    }
    
    func updateCount(type: UpdateType) {
        try! FactoryStorage.realm.write {
            switch type {
            case .plus:
                counter?.count += 1
            case .minus:
                counter?.count -= 1
            }
        }
    }
}
