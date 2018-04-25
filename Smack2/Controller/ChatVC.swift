//
//  ChatVC.swift
//  Smack2
//
//  Created by Bela Mate Barandi on 2/20/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var isTyping = false
    
    //Outlets
    
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTextBox: UITextField!
    
    @IBOutlet weak var typingUsersLabel: UILabel!
    @IBAction func messageBoxEditing(_ sender: Any) {
        //removed guard
        guard let channelID = MessageService.instance.selectedChannel?._id else {
            return
        }
        
        if messageTextBox.text == "" {
            isTyping = false
            sendButton.isEnabled = false
            sendButton.alpha = 0.5
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelID)

        } else {
            isTyping = true
            sendButton.isEnabled = true
            sendButton.alpha = 1
            SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelID)
        }
    }
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            
            //removed guard now its added back
            guard let channelId = MessageService.instance.selectedChannel?._id else {return}
            guard let message = messageTextBox.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                if success {
                    self.messageTextBox.text = ""
                    self.messageTextBox.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        
        //Trying to load default channel
       
        
        MessageService.instance.findAllChannel { (success) in
            
            //Trying to load default channel
           // MessageService.instance.selectedChannel = MessageService.instance.channels[0]
            if MessageService.instance.selectedChannel == nil {
                MessageService.instance.selectedChannel = MessageService.instance.channels[0]
            }
            SocketService.instance.getChannel { (success) in
                if success {
                    self.updateWithChannel()
                    print("na")
                } else {
                    debugPrint("valami")
                }
                
            }
        }
        
        
        sendButton.isEnabled = false
        messagesTableView.estimatedRowHeight = 80
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        SocketService.instance.getMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?._id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.messagesTableView.reloadData()
                                if MessageService.instance.messages.count > 0 {
                                    let endIndex = IndexPath(row: MessageService.instance.messages.count-1, section: 0)
                                    self.messagesTableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                                }
            }
        }
        
        
            
//        SocketService.instance.getMessage { (newMessage) in
//            if newMessage.channelId == MessageService.instance.selectedChannel {
//                self.messagesTableView.reloadData()
//                if MessageService.instance.messages.count > 0 {
//                    let endIndex = IndexPath(row: MessageService.instance.messages.count-1, section: 0)
//                    self.messagesTableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
//                }
//            }
//        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?._id else {return}
            var names = ""
            var numberOfTypers = 0
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if  names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUsersLabel.text  = "\(names) \(verb) typing a message"
            } else {
                self.typingUsersLabel.text = ""
            }
        }
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                
            })
        }
//        MessageService.instance.findAllChannel { (success) in
//
//            //Trying to load default channel
//            MessageService.instance.selectedChannel = MessageService.instance.channels[0]
//            SocketService.instance.getChannel { (success) in
//                if success {
//                    self.updateWithChannel()
//                    print("bazdmeg")
//                } else {
//                    debugPrint("valami")
//                }
//
//            }
//        }
        
        
    }
    
    //TableView functions
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    @objc func userDataDidChange(_ notif: Notification)  {
        if AuthService.instance.isLoggedIn {
            //get channel
        } else {
            channelNameLbl.text = "Please Log In"
            messagesTableView.reloadData()
        }
        
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.name ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
                // do stuff with channells
            }
        }
    }
    
    func getMessages(){
        
        let channelId = MessageService.instance.selectedChannel?._id ?? MessageService.instance.channels[0]._id
        print(channelId!)
        //guard let channelId = MessageService.instance.selectedChannel?._id else {
            //return
            //?? MessageService.instance.channels[0]._id
            
       // }
        MessageService.instance.findAllMessageForChannel(channelId: channelId!) { (success) in
            if success {
                self.messagesTableView.reloadData()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
