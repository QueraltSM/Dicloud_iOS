//
//  ChatWorker.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 5/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var chatTimer : Timer?
var allChats = [Chat]()
var notifiedChats = [Chat]()

struct ChatRoot: Codable {
    let messages: [Chat]
}

struct Chat : Codable {
    var from:String
    var from_id:Int
    var last_message_timestamp:String
    var messages_count:Int
}


class ChatWorker {
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func showNotification(from: String) {
        let message = "Tienes un chat pendiente con \(from)"
        appDelegate?.scheduleNotification(message: message, type: "chat")
    }

    func resetNotifiedChats() {
        for notifiedChat in notifiedChats {
            var contained = false
            var pos = 0
            for chat in allChats {
                if (notifiedChat.from_id == chat.from_id) {
                    contained = true
                }
            }
            if (!contained) {
                notifiedChats.remove(at: pos)
            }
            pos = pos + 1
        }
    }
    
    func decodeAllMessages() {
        resetNotifiedChats()
        for chat in allChats {
            var pos = 0
            var contained = false
            let from_id = chat.from_id
            for notifiedChat in notifiedChats {
                if (notifiedChat.from_id == from_id) {
                    contained = true
                }
            }
            if (!contained) {
                notifiedChats.append(chat)
                self.showNotification(from:chat.from)
            }
            pos = pos + 1
        }
    }
    
    @objc func checkMessages() {
        let getChatURL = "https://app.dicloud.es/getPendingMessages.asp"
        let getChatParameters = ["password":password,"aliasDb":nickname,"appSource":"Dicloud","user":username, "token": token]
        Alamofire.request(getChatURL, method: .post, parameters: getChatParameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let allMessages = try JSONDecoder().decode(ChatRoot.self,from: (response.data)!)
                    allChats = allMessages.messages
                    self.decodeAllMessages()
                }
                catch {
                    print(error)
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }

    func start(time: Int){
        if chatTimer == nil && time > 0 {
            chatTimer =  Timer.scheduledTimer(
                timeInterval: TimeInterval(time),
                target      : self,
                selector    : #selector(self.checkMessages),
                userInfo    : nil,
                repeats     : true)
        }
    }
    
    func stop() {
        if chatTimer != nil {
            chatTimer!.invalidate()
            chatTimer = nil
        }
    }
}
