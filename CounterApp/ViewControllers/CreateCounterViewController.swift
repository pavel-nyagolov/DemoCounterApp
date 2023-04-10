//
//  ViewController.swift
//  CounterApp
//
//  Created by Pavel on 6.04.23.
//

import UIKit

class CreateCounterViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton.isEnabled = false
    }
    
    
    @IBAction func titleTextFieldChanged(_ sender: UITextField) {
        if sender.text != "" {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
    }
    
    @IBAction func didPressedCreate(_ sender: UIButton) {
        let newCounter = CounterModel()
        newCounter.title = titleTextField.text!
        FactoryStorage.addCounter(newCounter)
        navigationController?.popToRootViewController(animated: true)
    }
    
}

