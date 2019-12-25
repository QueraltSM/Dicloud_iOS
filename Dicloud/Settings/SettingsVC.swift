//
//  SettingsVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 5/12/19.
//  Copyright © 2019 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    var settings: [String] = []
    var settingsImage: [String] = []
    var settingsSegue: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings = ["Notificaciones", "Datos de uso"]
        settingsImage = ["icons8-notification-24", "icons8-refresh-24"]
        settingsSegue = ["NotificationsVCSegue", "DataUseVCSegue"]
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.backgroundColor = UIColor.white
        self.myTableView.backgroundView?.backgroundColor = UIColor.white
    }

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! SettingsCell
        cell.settingOption.setTitle(settings[indexPath.row], for: .normal)
        cell.imageView!.image = UIImage(named: settingsImage[indexPath.row])
        cell.settingOption.addTarget(self, action: Selector(("onClicked:")), for: .touchUpInside)
        return cell
    }    
}
