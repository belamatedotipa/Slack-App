//
//  AvatarCell.swift
//  Smack2
//
//  Created by Bela Mate Barandi on 2/28/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    
    
    
    
    
    
    
    
}
