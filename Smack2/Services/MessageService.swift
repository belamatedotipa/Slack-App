//
//  MessageService.swift
//  Smack2
//
//  Created by Bela Mate Barandi on 3/19/18.
//  Copyright © 2018 Bela Mate Barandi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel : Channel?
    var unreadChannels = [String]()
    var messages = [Message]()
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        if AuthService.instance.isLoggedIn {
            Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
                if response.result.error == nil {
                    guard let data = response.data else { return }
                    do {
                        self.channels = try JSONDecoder().decode([Channel].self, from: data)
                    } catch let error {
                        debugPrint(error as Any)
                    }
                    print(self.channels)
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                    //                if let json = JSON(data: data).array {
                    //                    for item in json {
                    //                        let name = item["name"].stringValue
                    //                        let channelDescription = item["description"].stringValue
                    //                        let id = item["_id"].stringValue
                    //                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                    //                        self.channels.append(channel)
                    //                    }
                    //                }
                } else {
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
            }
        }
        else {
            return
        }
        
}
    
    func findAllMessageForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }

                do {
                    self.messages = try JSONDecoder().decode([Message].self, from: data)
                } catch let error {
                    debugPrint(error as Any)
                }
                print(self.messages)
                completion(true)
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        
        
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
    
    
}
    

