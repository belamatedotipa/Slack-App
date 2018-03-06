//
//  CircleImage.swift
//  Smack2
//
//  Created by Bela Mate Barandi on 3/6/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    
    override func awakeFromNib() {
        setUpView()
    }
    
    func setUpView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }

}
