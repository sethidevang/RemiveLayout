//
//  ViewController.swift
//  loginPage
//
//  Created by Devang IOS on 16/01/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var googleButtonOutlet: UIButton!
    
    @IBOutlet weak var appleButtonOutlet: UIButton!
    
    @IBOutlet weak var withoutLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleButtonOutlet.layer.borderWidth=1
        googleButtonOutlet.layer.cornerRadius=16
        appleButtonOutlet.layer.borderWidth = 1
        appleButtonOutlet.layer.cornerRadius=16
        withoutLogin.layer.cornerRadius=16
//        withoutLogin.layer.borderWidth=1
        // Do any additional setup after loading the view.
    }

    @IBAction func googleLogin(_ sender: UIButton) {
        
    }
    
}

