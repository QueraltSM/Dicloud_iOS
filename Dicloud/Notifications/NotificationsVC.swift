//
//  NotificationsVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 8/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

var led_vc : LedVC!

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
 {
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
        } else {
            enableNotificationsCells(userInteractionEnabled:true)
        }
        myTableView.reloadData()
    }
    
    @objc func checkCellVibrationValueChange(mySwitch: UISwitch) {
        defaults.set(mySwitch.isOn, forKey: "vibration_switch_value")
    }
    
    func showPopOver(){
        led_vc = self.storyboard?.instantiateViewController(withIdentifier: "LedVC") as? LedVC
        led_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(led_vc)
        self.view.addSubview(led_vc.view)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1) {
            performSegue(withIdentifier: "SoundsVC", sender: nil)
        } else if (indexPath.row == 3) {
            showPopOver()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let showNotifications = UserDefaults.standard.object(forKey: "notifications_switch_value") as! Bool
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as! NotificationsCheckCell
            setNotificationsCell(cell: cell, showNotifications: showNotifications)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chooseCell") as! NotificationsChooseCell
            setSoundCell(cell: cell, showNotifications: showNotifications)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as! NotificationsCheckCell
            setVibrationCell(cell: cell, showNotifications: showNotifications)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ledCell") as! NotificationsLedCell
            setLedCell(cell: cell, showNotifications: showNotifications)
            return cell
        }
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
    
    func setLedCell(cell: NotificationsLedCell, showNotifications: Bool) {
        if (UserDefaults.standard.object(forKey: "led_color_selected") == nil) {
            defaults.set("Rojo", forKey: "led_color_selected")
        }
        cell.title.text = "Led"
        cell.color.text = UserDefaults.standard.object(forKey: "led_color_selected") as? String
        cell.title.isEnabled = showNotifications 
        cell.color.isEnabled = showNotifications 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
