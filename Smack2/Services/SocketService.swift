//
//  SocketService.swift
//  Smack2
//
//  Created by Bela Mate Barandi on 3/22/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
   
   // var socket : SocketManager = SocketManager(socketURL: URL(string: BASE_URL_LOCAL)!)
    

    
    let manager = SocketManager(socketURL: URL(string: BASE_URL_LOCAL)!)
    lazy var socket:SocketIOClient = manager.defaultSocket
    


    
    

    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            let newChannel = Channel(_id: channelId, name: channelName, description: channelDesc, __v: 0)
            MessageService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
             guard let userName = dataArray[3] as? String else {return}
             guard let userAvatar = dataArray[1] as? String else {return}
             guard let userAvatarColor = dataArray[1] as? String else {return}
             guard let _id = dataArray[6] as? String else {return}
             guard let timestamp = dataArray[7] as? String else {return}
            
            let newMessage = Message(_id: _id, messageBody: msgBody, userId: "", channelId: channelId, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, __v: 0, timeStamp: timestamp)
            completion(newMessage)
            
//            if channelId == MessageService.instance.selectedChannel?._id && AuthService.instance.isLoggedIn {
//
//                MessageService.instance.messages.append(newMessage)
//                completion(true)
//            } else {
//                completion(false)
//            }
            
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else {return}
            completionHandler(typingUsers)
            
        }
    }
    
    
    
    
    
}
