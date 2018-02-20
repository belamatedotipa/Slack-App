//
//  ChannelVC.swift
//  Smack2
//
//  Created by Bela Mate Barandi on 2/20/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = (self.view.frame.size.width - (self.view.frame.size.width/6))
        print(self.view.frame.size.width)
    }

    

}
