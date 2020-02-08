//
//  ViewController.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 4/10/19.
//  Copyright © 2019 Queralt Sosa Mompel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {
    
    let url = "https://app.dicloud.es/login.asp";
    let imageView = UIImageView()
    let hidePassword = "https://img.icons8.com/ios-glyphs/50/000000/hide.png"
    let showPassword = "https://img.icons8.com/ios-glyphs/50/000000/visible.png"
    var passwordHidden = true
    
    var token = ""
    var companyID = ""
    var fullname = ""
    var listin = ""
    var develop = ""
    var app = ""
    var domain = ""
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var nickname: textfieldDesign!
    @IBOutlet weak var username: textfieldDesign!
    @IBOutlet weak var password: textfieldDesign!
    @IBOutlet weak var nickLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var passwordlbl: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.snapshotView(afterScreenUpdates: true)
        nickname.setStyle(color: UIColor.white)
        username.setStyle(color: UIColor.white)
        password.setStyle(color: UIColor.white)
        loginBtn.layer.cornerRadius = loginBtn.bounds.height / 2
        let roundPath = UIBezierPath(roundedRect: loginBtn.bounds, cornerRadius: loginBtn.bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        loginBtn.layer.mask = maskLayer
    }
    
    
    @IBAction func nicknameTouched(_ sender: Any) {
        nickname.setStyle(color: UIColor.white)
    }
    
    @IBAction func usernameTouched(_ sender: Any) {
        username.setStyle(color: UIColor.white)
    }
    
    @IBAction func passwordTouched(_ sender: Any) {
        password.setStyle(color: UIColor.white)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        let when = DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func everyFldIsFull() -> Bool {
        var result = true
        if ((nickname.text?.isEmpty)!) {
            result = false
            nickname.setStyle(color: UIColor.red)
        }
        if ((username.text?.isEmpty)!) {
            result = false
            username.setStyle(color: UIColor.red)
        }
        if ((password.text?.isEmpty)!) {
            result = false
            password.setStyle(color: UIColor.red)
        }
        if (!result) {
            showAlert(title: "Error al iniciar sesión",message: "Todos los campos son obligatorios")
        }
        return result
    }
    
    func makeLoginRequest() {
        var loginParameters : Dictionary = [String: String]()
        loginParameters["password"] = password.text!
        loginParameters["aliasDb"] = nickname.text!
        loginParameters["appSource"] = "Dicloud"
        loginParameters["user"] = username.text!
        Alamofire.request(url, method: .post, parameters: loginParameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    self.decodeJSON(json: JSON)
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        if (everyFldIsFull()) {
            makeLoginRequest()
        }
    }
    
    func showSegue(title: String, dom: String) {
        self.app = title
        self.domain = dom
        self.performSegue(withIdentifier: "HomeSegue", sender: [self.token, self.listin, self.develop, self.fullname])
    }
    
    func showDevelopAlert() {
        let alert = UIAlertController(title: "Selecciona a qué aplicación quieres acceder:", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Desarrollo", style: .destructive, handler: { (action: UIAlertAction!) in
            self.showSegue(title: "Desarrollo", dom: "desarrollo")
        }))
        alert.addAction(UIAlertAction(title: "Dicloud", style: .cancel, handler: { (action: UIAlertAction!) in
            self.showSegue(title: "Dicloud", dom: "admin")
        }))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeVC {
            print("entro")
            UserDefaults.standard.set(nickname.text!, forKey: "nickname")
            UserDefaults.standard.set(username.text!, forKey: "username")
            UserDefaults.standard.set(fullname, forKey: "fullname")
            UserDefaults.standard.set(password.text!, forKey: "password")
            UserDefaults.standard.set(token, forKey: "token")
            UserDefaults.standard.set(companyID, forKey: "companyID")
            UserDefaults.standard.set(listin, forKey: "listin")
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.set(develop, forKey: "develop")
            UserDefaults.standard.set(app, forKey: "app")
            UserDefaults.standard.set(domain, forKey: "domain")
            UserDefaults.standard.synchronize()
        }
    }
    
    func decodeJSON(json: NSDictionary) {
        let errorCode = json["error_code"] as! Int
        if (errorCode != 1) {
            nickLbl.isHidden = true
            nickname.setUnderline(color: UIColor.gray)
        }
        var errorMsg = ""
        switch errorCode {
        case 0: // success
            listin = json["listin"]! as! String
            develop = json["desarrollo"]! as! String
            fullname = json["fullName"]! as! String
            companyID = String (describing: json["companyid"])
            token = json["token"]! as! String
            if (develop == "true") {
                showDevelopAlert()
            } else {
                self.showSegue(title: "Dicloud", dom: "admin")
            }
            break
        case 1: // company error
            errorMsg = "Alias incorrecto"
            nickname.setStyle(color: UIColor.red)
            nickname.text = ""
            break
        case 2:  // user or password error
            errorMsg = "Usuario o contraseña incorrectas"
            username.setStyle(color: UIColor.red)
            password.setStyle(color: UIColor.red)
            username.text = ""
            password.text = ""
            break
        case 3:// inactive user error
            errorMsg = "Este usuario se encuentra desactivado"
            break
        case 4: // json error
            errorMsg = "Ha habido algún problema en la comunicación"
            break
        case 5: // internet error
            errorMsg = "No hay conexión a internet"
            break
        default: // unknown error
            errorMsg = "Error desconocido"
        }
        if (errorMsg != "") {
            showAlert(title: "Error al iniciar sesión", message: errorMsg)
        }
    }
}

extension UITextField {
    func setStyle(color: UIColor) {
        self.layer.cornerRadius = self.bounds.height / 2
        let roundPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        self.layer.mask = maskLayer
        self.layer.borderWidth = 2.0
        self.layer.borderColor = color.cgColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
