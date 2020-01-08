//
//  LedVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 8/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class LedVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var leds: UIPickerView!
    var data: [String] = []
    var led_color_selected: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = [
            "Rojo",
            "Azul",
            "Verde",
            "Amarillo"
        ]
        leds.delegate = self
        leds.dataSource = self
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
        led_color_selected = data[row] as String
    }
    
    @IBAction func saveLedColor(_ sender: Any) {
        defaults.set(led_color_selected, forKey: "led_color_selected")
        performSegue(withIdentifier: "NotificationsVC", sender: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        performSegue(withIdentifier: "NotificationsVC", sender: nil)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label:UILabel
        if let v = view as? UILabel{
            label = v
        }
        else {
            label = UILabel()
        }
        label.textAlignment = .center
        label.text = data[row]
        switch(data[row]) {
        case "Rojo":
            label.textColor = UIColor.red
            break
        case "Azul":
            label.textColor = UIColor.blue
            break
        case "Verde":
            label.textColor = UIColor.green
            break
        default:
            label.textColor = UIColor.yellow
        }
        return label
    }

}
