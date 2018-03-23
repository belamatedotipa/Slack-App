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
    
    
    
}
