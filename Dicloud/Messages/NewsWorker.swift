//
//  NewsWorker.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 4/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UserNotifications

var newsTimer : Timer?
var allNews = [New]()
var notifiedNews = [New]()

struct NewRoot: Codable {
    let messages: [New]
}

struct New : Codable {
    var from:String
    var from_id:Int
    var last_message_timestamp:String
    var messages_count:Int
}

class NewsWorker {
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func showNotification(new: New) {
        var total = "mensaje"
        if (new.messages_count > 1) {
            total = "mensajes"
        }
        let message = "Tienes \(new.messages_count) \(total) de \(new.from)"
        print("news = \(message)")
        appDelegate?.scheduleNotification(message: message, type:"news")
        
    }
    
    func resetNotifiedNews() {
        for notifiedNew in notifiedNews {
            var contained = false
            var pos = 0
            for new in allNews {
                if (notifiedNew.from_id == new.from_id) {
                    contained = true
                    if (notifiedNew.messages_count > new.messages_count) {
                        notifiedNews.remove(at: pos)
                        notifiedNews.append(new)
                    }
                }
            }
            if (!contained) {
                notifiedNews.remove(at: pos)
            }
            pos = pos + 1
        }
    }
    
    func decodeAllMessages() {
        resetNotifiedNews()
        for new in allNews {
            var contained = false
            var pos = 0
            let from_id = new.from_id
            let messages_count = new.messages_count
            for notifiedNew in notifiedNews {
                if (notifiedNew.from_id == from_id && notifiedNew.messages_count < messages_count) {
                    contained = true
                    notifiedNews.remove(at: pos)
                    let updatedNew = New(from: new.from, from_id: new.from_id, last_message_timestamp: new.last_message_timestamp, messages_count: new.messages_count)
                    notifiedNews.append(updatedNew)
                    self.showNotification(new:updatedNew)
                } else if (notifiedNew.from_id == from_id && notifiedNew.messages_count > messages_count) {
                    notifiedNews.remove(at: pos)
                    let updatedNew = New(from: new.from, from_id: new.from_id, last_message_timestamp: new.last_message_timestamp, messages_count: new.messages_count)
                    notifiedNews.append(updatedNew)
                } else if (notifiedNew.from_id == from_id) {
                    contained = true
                }
                pos = pos + 1
            }
            if (!contained) {
                notifiedNews.append(new)
                self.showNotification(new:new)
            }
        }
    }
    
    @objc func checkMessages() {
        let getNewsURL = "https://app.dicloud.es/getPendingNews.asp"
        let getNewsParameters = ["password":password,"aliasDb":nickname,"appSource":"Dicloud","user":username, "token": token]
        Alamofire.request(getNewsURL, method: .post, parameters: getNewsParameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let allMessages = try JSONDecoder().decode(NewRoot.self,from: (response.data)!)
                    allNews = allMessages.messages
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
        if newsTimer == nil && time > 0 {
            newsTimer =  Timer.scheduledTimer(
                timeInterval: TimeInterval(time),
                target      : self,
                selector    : #selector(self.checkMessages),
                userInfo    : nil,
                repeats     : true)
        }
    }
    
    func stop() {
        if newsTimer != nil {
            newsTimer!.invalidate()
            newsTimer = nil
        }
    }
}
