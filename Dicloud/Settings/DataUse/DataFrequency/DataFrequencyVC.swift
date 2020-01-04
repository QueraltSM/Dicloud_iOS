//
//  DataFrequencyVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 3/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

var defaults: UserDefaults = UserDefaults.standard

class DataFrequencyVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
        frequency.delegate = self
        frequency.dataSource = self
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
