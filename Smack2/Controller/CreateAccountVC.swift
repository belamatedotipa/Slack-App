//
//  CreateAccountVC.swift
//  Smack2
//
//  Created by Bela Mate Barandi on 2/23/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = emailTxt.text , emailTxt.text != "" else {
            return
        }
        guard let password = passTxt.text , passTxt.text != "" else {
            return
        }
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            
            if success {
                print("registered user!")
            }
        }
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
}
