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
        let value = mySwitch.isOn
        defaults.set(value, forKey: "vibration_switch_value")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let showNotifications = UserDefaults.standard.object(forKey: "notifications_switch_value")
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as! NotificationsCheckCell
            cell.title.text = "Notificaciones de mensajes"
            if (showNotifications == nil) {
                defaults.set(true, forKey: "notifications_switch_value")
            }
            cell.state.isOn = showNotifications as! Bool
            cell.state.addTarget(self, action: #selector(checkCellValueChange), for:UIControl.Event.valueChanged)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chooseCell") as! NotificationsChooseCell
            cell.title.text = "Sonido"
            cell.sound.text = "El predeterminado"
            cell.title.isEnabled = showNotifications as! Bool
            cell.sound.isEnabled = showNotifications as! Bool
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as! NotificationsCheckCell
            cell.title.text = "Vibración"
            if (UserDefaults.standard.object(forKey: "vibration_switch_value") == nil) {
                defaults.set(true, forKey: "vibration_switch_value")
            }
            cell.state.isOn = UserDefaults.standard.object(forKey: "vibration_switch_value") as! Bool
            cell.state.addTarget(self, action: #selector(checkCellVibrationValueChange), for:UIControl.Event.valueChanged)
            cell.title.isEnabled = showNotifications as! Bool
            cell.state.isEnabled = showNotifications as! Bool
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ledCell") as! NotificationsLedCell
            cell.title.text = "Led"
            cell.color.text = "Rojo/falta imagen izquierda"
            cell.title.isEnabled = showNotifications as! Bool
            cell.color.isEnabled = showNotifications as! Bool
            return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
