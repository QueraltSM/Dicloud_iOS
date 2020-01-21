//
//  NotificationsVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 8/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
 {
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.snapshotView(afterScreenUpdates: true)
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func enableNotificationsCells(userInteractionEnabled: Bool) {
        let cells = self.myTableView.visibleCells
        var index = 0
        for cell in cells {
            if (index > 0) {
                cell.isUserInteractionEnabled = userInteractionEnabled
            }
            index = index + 1
        }
        myTableView.reloadData()
    }
    
    @objc func checkCellValueChange(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        defaults.set(value, forKey: "notifications_switch_value")
        if (!value) {
            enableNotificationsCells(userInteractionEnabled:false)
            newsTimer?.invalidate()
            chatTimer?.invalidate()
        } else {
            enableNotificationsCells(userInteractionEnabled:true)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.confirmUserAuthorization()
            appDelegate.applicationDidBecomeActive(UIApplication.shared)
            
        }
        myTableView.reloadData()
    }
    
    @objc func checkCellVibrationValueChange(mySwitch: UISwitch) {
        defaults.set(mySwitch.isOn, forKey: "vibration_switch_value")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1) {
            performSegue(withIdentifier: "SoundsVC", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let showNotifications = UserDefaults.standard.object(forKey: "notifications_switch_value") as! Bool
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as! NotificationsCheckCell
            setNotificationsCell(cell: cell, showNotifications: showNotifications)
            setCellBackgroundView(cell: cell, color:"#FFFFFF")
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chooseCell") as! NotificationsChooseCell
            setSoundCell(cell: cell, showNotifications: showNotifications)
            setCellBackgroundView(cell: cell, color:"#DDF4FF")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as! NotificationsCheckCell
            setVibrationCell(cell: cell, showNotifications: showNotifications)
            setCellBackgroundView(cell: cell, color:"#FFFFFF")
            return cell
        }
    }
    
    func setCellBackgroundView(cell: UITableViewCell, color: String) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(hexString: color)
        cell.selectedBackgroundView = backgroundView
    }
    
    func setNotificationsCell(cell: NotificationsCheckCell, showNotifications: Bool) {
        cell.title.text = "Notificaciones de mensajes"
        cell.state.isOn = showNotifications
        cell.state.addTarget(self, action: #selector(checkCellValueChange), for:UIControl.Event.valueChanged)
    }
    
    func setSoundCell(cell:NotificationsChooseCell, showNotifications: Bool) {
        cell.title.text = "Sonido"
        if (UserDefaults.standard.object(forKey: "sound_notification_title") == nil) {
            defaults.set("Message received", forKey: "sound_notification_title")
        }
        cell.sound.text = UserDefaults.standard.object(forKey: "sound_notification_title") as? String
        cell.title.isEnabled = showNotifications 
        cell.sound.isEnabled = showNotifications 
    }
    
    func setVibrationCell(cell:NotificationsCheckCell, showNotifications: Bool) {
        cell.title.text = "Vibración"
        if (UserDefaults.standard.object(forKey: "vibration_switch_value") == nil) {
            defaults.set(true, forKey: "vibration_switch_value")
        }
        cell.state.isOn = UserDefaults.standard.object(forKey: "vibration_switch_value") as! Bool
        cell.state.addTarget(self, action: #selector(checkCellVibrationValueChange), for:UIControl.Event.valueChanged)
        cell.title.isEnabled = showNotifications 
        cell.state.isEnabled = showNotifications 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
