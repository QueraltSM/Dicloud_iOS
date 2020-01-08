//
//  SoundsVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 8/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit
import AVFoundation

class SoundsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sounds: [String] = []
    var soundNotificationTitle: String = ""
    var soundNotificationID: UInt32 = 0
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        sounds = ["New mail","Mail sent", "Voice mail", "Message received", "Message sent", "Alarm",
                  "Low power","Sms received I", "Sms received II", "Sms received III", "Sms received IV"]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel!.text = sounds[indexPath.row]
        cell?.textLabel!.textAlignment = .center
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        soundNotificationTitle = sounds[indexPath.row]
        soundNotificationID = UInt32(1000+indexPath.row)
        AudioServicesPlayAlertSound(UInt32(1000+indexPath.row))
    }

    @IBAction func saveNewNotificationSound(_ sender: Any) {
        defaults.set(soundNotificationTitle, forKey: "sound_notification_title")
        defaults.set(soundNotificationID, forKey: "sound_notification_id")
        performSegue(withIdentifier: "NotificationsVC", sender: nil)
    }
}
