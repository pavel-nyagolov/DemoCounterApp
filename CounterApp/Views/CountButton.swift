//
//  CountButton.swift
//  CounterApp
//
//  Created by Pavel on 6.04.23.
//

import UIKit

@IBDesignable
class CountButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            if cornerRadius == 0 {
                self.layer.cornerRadius = layer.frame.height / 2
            } else {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addShadow()
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5.0
    }
}
