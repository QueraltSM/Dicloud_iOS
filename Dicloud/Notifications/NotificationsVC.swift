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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as! NotificationsCheckCell
            cell.title.text = "Notificaciones de mensajes"
            cell.state.isOn = true
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chooseCell") as! NotificationsChooseCell
            cell.title.text = "Sonido"
            cell.sound.text = "El predeterminado"
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell") as! NotificationsCheckCell
            cell.title.text = "Vibración"
            cell.state.isOn = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ledCell") as! NotificationsLedCell
            cell.title.text = "Led"
            cell.color.text = "Rojo/falta imagen izquierda"
            return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
