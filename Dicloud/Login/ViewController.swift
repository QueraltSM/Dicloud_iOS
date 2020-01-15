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
    
    @IBOutlet weak var nickname: textfieldDesign!
    @IBOutlet weak var username: textfieldDesign!
    @IBOutlet weak var password: textfieldDesign!
    @IBOutlet weak var nickLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var passwordlbl: UILabel!
    @IBOutlet weak var errorLabel: SSPaddingLabel!
    
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
        nickname.directionMaterial = placeholderDirection.placeholderUp
        username.directionMaterial = placeholderDirection.placeholderUp
        password.directionMaterial = placeholderDirection.placeholderUp
        errorLabel.layer.cornerRadius = 10
        errorLabel.layer.masksToBounds = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeVC {
            UserDefaults.standard.set(nickname.text!, forKey: "nickname")
            UserDefaults.standard.set(username.text!, forKey: "username")
            UserDefaults.standard.set(fullname, forKey: "fullname")
            UserDefaults.standard.set(password.text!, forKey: "password")
            UserDefaults.standard.set(token, forKey: "token")
            UserDefaults.standard.set(companyID, forKey: "companyID")
            UserDefaults.standard.set(listin, forKey: "listin")
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.synchronize()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.confirmUserAuthorization()
            appDelegate.applicationDidBecomeActive(UIApplication.shared)
        }
    }
    
    func decodeJSON(json: NSDictionary) {
        let errorCode = json["error_code"] as! Int
        if (errorCode != 1) {
            nickLbl.isHidden = true
            nickname.setUnderline(color: UIColor.gray)
        }
        switch errorCode {
        case 0: // success
            listin = json["listin"]! as! String
            fullname = json["fullName"]! as! String
            companyID = String (describing: json["companyid"])
            token = json["token"]! as! String
            self.performSegue(withIdentifier: "HomeSegue", sender: [token, listin, fullname])
            break
        case 1: // company error
            nickLbl.text = "Alias incorrecto"
            nickLbl.isHidden = false // Nickname is wrong
            nickname.setUnderline(color: UIColor.red)
            break
        case 2:  // user or password error
            showError(error: "Usuario o contraseña incorrectas")
            break
        case 3:// inactive user error
            showError(error: "Este usuario se encuentra desactivado")
            break
        case 4: // json error
            showError(error: "Ha habido algún problema en la comunicación")
            break
        case 5: // internet error
            showError(error: "No hay conexión a internet")
            break
        default: // unknown error
            showError(error: "Error desconocido")
        }
    }
    
    func showError(error: String) {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorLabel.backgroundColor = UIColor.white
        errorLabel.padding = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        errorLabel.text = error
        errorLabel.sizeToFit()
        errorLabel.layer.cornerRadius = errorLabel.frame.height/2
        errorLabel.layer.masksToBounds = true
        errorLabel.isHidden = false
        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.white
        errorLabel.backgroundColor = UIColor.gray
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.errorLabel.isHidden = true
        }
    }
}


class SSPaddingLabel: UILabel {
    var padding : UIEdgeInsets
    
    // Create a new SSPaddingLabel instance programamtically with the desired insets
    required init(padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
        self.padding = padding
        super.init(frame: CGRect.zero)
    }
    
    // Create a new SSPaddingLabel instance programamtically with default insets
    override init(frame: CGRect) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(frame: frame)
    }
    
    // Create a new SSPaddingLabel instance from Storyboard with default insets
    required init?(coder aDecoder: NSCoder) {
        padding = UIEdgeInsets.zero // set desired insets value according to your needs
        super.init(coder: aDecoder)
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
    }
    
    // Override `intrinsicContentSize` property for Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    // Override `sizeThatFits(_:)` method for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
