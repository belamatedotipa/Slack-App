//
//  MessageTableViewCell.swift
//  Smack2
//
//  Created by Bela Mate Barandi on 3/26/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    
    //Outlets
    @IBOutlet weak var avatarImage: CircleImage!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(message: Message) {
        messageLbl.text = message.messageBody
        nameLbl.text = message.userName

        avatarImage.image = UIImage(named: message.userAvatar)
        avatarImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
    
        guard var isoDate = message.timeStamp else { return }
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, H:mm a"
        
        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate)
            timestampLbl.text = finalDate
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
