//
//  Main.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 8/2/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

class Main: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let userLoginStatus = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
            print("user")
            print(userLoginStatus)
            if(userLoginStatus){
                self.startLoginVC()
                //self.startHomeVC()
            } else {
                self.startLoginVC()
            }
        }
    }
    
    func startHomeVC() {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.present(nextVC, animated: false, completion: nil)
    }
    
    func startLoginVC() {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(nextVC, animated: false, completion: nil)
    }
}
