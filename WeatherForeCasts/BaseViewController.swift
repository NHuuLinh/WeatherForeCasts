//
//  BaseViewController.swift
//  WeatherForeCasts
//
//  Created by Huu Linh Nguyen on 26/6/26.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigationBar()
        setupview()
        
    }
    func hideNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func setupview(){
        let tapGetsure = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGetsure.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGetsure)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

    
}
