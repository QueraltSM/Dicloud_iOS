//
//  DataUseVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 3/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class DataUseVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

     var frequency_vc : DataFrequencyVC!
    @IBOutlet weak var myTableView: UITableView!
    var dataUseOptions: [String] = []
    var dataUseSegue: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frequency_vc = self.storyboard?.instantiateViewController(withIdentifier: "DataFrequencyVC") as? DataFrequencyVC
        dataUseOptions = ["Frecuencia de sincronización"]
        dataUseSegue = ["DataFrequencySegue"]
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.backgroundColor = UIColor.white
        self.myTableView.backgroundView?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return dataUseOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! DataUseCell
        cell.dataUseOptions.text = dataUseOptions[indexPath.row]
        //cell.dataUseSubOptions.text = dataUseSubOptions[0] // change for the one selected
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let nextSegue = dataUseSegue[(indexPath?.row)!]
        if nextSegue == "DataFrequencySegue" {
            showPopOver()
        }
    }
    
    func showPopOver(){
        self.frequency_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(frequency_vc)
        self.view.addSubview(frequency_vc.view)
    }
}
