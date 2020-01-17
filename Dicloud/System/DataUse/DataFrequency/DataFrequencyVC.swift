//
//  DataFrequencyVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 3/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

var defaults: UserDefaults = UserDefaults.standard

class DataFrequencyVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var myTableView: UITableView!
    var data: [String] = []
    @IBOutlet weak var frequency: UIPickerView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        data = [
            "Cada 15 minutos",
            "Cada 30 minutos",
            "Cada hora",
            "Cada 3 horas",
            "Cada 5 horas",
            "Nunca",
        ]
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.backgroundColor = UIColor.white
        self.myTableView.backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Frecuencia de sincronización"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection
        section: Int) -> String? {
        return "Frecuencia de sincronización"
    }*/
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(hexString: "#DDF4FF")
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let data_frequency_selected = data[(indexPath?.row)!] as String
        defaults.set(data_frequency_selected, forKey: "data_frequency_selected")
        performSegue(withIdentifier: "DataUseVCSegue", sender: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let data_frequency_selected = data[row] as String
        defaults.set(data_frequency_selected, forKey: "data_frequency_selected")
        performSegue(withIdentifier: "DataUseVCSegue", sender: nil)
    }
}
