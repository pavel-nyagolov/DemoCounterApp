//
//  LoadingView.swift
//  CounterApp
//
//  Created by Pavel on 6.04.23.
//

import UIKit

struct LoadingView {
    var spinnerView: UIView?
    var blurEffectView: UIVisualEffectView?
    
    var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    var spinner = UIActivityIndicatorView(style: .large)
}
