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

class ViewController: UIViewController {
    
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
    
    @IBOutlet weak var nickname: textfieldDesign!
    @IBOutlet weak var username: textfieldDesign!
    @IBOutlet weak var password: textfieldDesign!
    @IBOutlet weak var nickLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var passwordlbl: UILabel!
    
    var textFieldBtn: UIButton {
        let button = UIButton(type: .custom)
        var urlPasswordIcon = URL(string: showPassword)
        if (passwordHidden) {
            urlPasswordIcon = URL(string: hidePassword)
        }
        let data = try? Data(contentsOf: urlPasswordIcon!)
        imageView.image = UIImage(data: data!)
        button.setImage(imageView.image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(password.frame.size.width - 40), y: CGFloat(5), width: CGFloat(20), height: CGFloat(20))
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(self.refreshContent), for: .touchUpInside)
        return button
    }
    
    @objc func refreshContent() {
        if (password.isSecureTextEntry) {
            password.isSecureTextEntry = false
            passwordHidden = false
        } else {
            password.isSecureTextEntry = true
            passwordHidden = true
        }
        password.rightView = textFieldBtn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.snapshotView(afterScreenUpdates: true)
        nickname.directionMaterial = placeholderDirection.placeholderUp
        username.directionMaterial = placeholderDirection.placeholderUp
        password.directionMaterial = placeholderDirection.placeholderUp
        nickname.setUnderline(color: UIColor.gray)
        username.setUnderline(color: UIColor.gray)
        password.setUnderline(color: UIColor.gray)
        password.rightView = textFieldBtn
        password.rightViewMode = .always
    }
    
    @IBAction func nicknameEditEnd(_ sender: Any) {
        if (nickLbl.isHidden) {
            nickname.setUnderline(color: UIColor.gray)
        }
    }
    
    @IBAction func usernameEditEnd(_ sender: Any) {
        if (usernameLbl.isHidden) {
            username.setUnderline(color: UIColor.gray)
        }
    }
    
    @IBAction func passwordEditEnd(_ sender: Any) {
        if (passwordlbl.isHidden) {
            password.setUnderline(color: UIColor.gray)
        }
    }
    
    @IBAction func nicknameTouched(_ sender: Any) {
        if (nickLbl.isHidden) {
            nickname.setUnderline(color: UIColor.blue)
        }
    }
    
    @IBAction func usernameTouched(_ sender: Any) {
        if (usernameLbl.isHidden) {
            username.setUnderline(color: UIColor.blue)
        }
    }
    
    @IBAction func passwordTouched(_ sender: Any) {
        if (passwordlbl.isHidden) {
            password.setUnderline(color: UIColor.blue)
        }
    }

    func textfieldsAreEmpty() -> Bool {
        var emptiness: Bool = false
        if ((nickname.text?.isEmpty)!) {
            nickLbl.isHidden = false
            nickname.setUnderline(color: UIColor.red)
            emptiness = true
        } else {
            nickLbl.isHidden = true
            nickname.setUnderline(color: UIColor.gray)
        }
        if ((username.text?.isEmpty)!) {
            usernameLbl.isHidden = false
            username.setUnderline(color: UIColor.red)
            emptiness = true
        } else {
            usernameLbl.isHidden = true
            username.setUnderline(color: UIColor.gray)
        }
        if ((password.text?.isEmpty)!) {
            passwordlbl.isHidden = false
            password.setUnderline(color: UIColor.red)
            emptiness = true
        } else {
            passwordlbl.isHidden = true
            password.setUnderline(color: UIColor.gray)
        }
        return emptiness
    }
    
    
    @IBAction func login(_ sender: Any) {
        if (textfieldsAreEmpty()) {
            return
        }
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
            nickLbl.text = "Alias incorrecto"
            nickLbl.isHidden = false // Nickname is wrong
            nickname.setUnderline(color: UIColor.red)
            break
        case 2:  // user or password error
            errorMsg = "Usuario o contraseña incorrectas"
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
            let alert = UIAlertController(title: "Error al iniciar sesión", message: errorMsg, preferredStyle: .alert)
            self.present(alert, animated: true)
            let when = DispatchTime.now() + 4
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
