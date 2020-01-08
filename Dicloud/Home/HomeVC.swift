//
//  HomeVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 6/10/19.
//  Copyright © 2019 Queralt Sosa Mompel. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftyJSON

var URL_INDEX: String = ""
var URL_MENU: String = ""
var userMenu = [UserMenu]()
var goHomeView: Bool = true
var password: String = ""
var nickname: String = ""
var username: String = ""
var token: String = ""
var listin: String = ""

struct Root: Codable {
    let usermenu: [UserMenu]
}

struct UserMenu : Codable {
    var agent_id:Int
    var id:String
    var menu:String
    var submenu:String
    var url:URL
}

var myWebView: WKWebView!

class HomeVC: UIViewController {
    
    var popupWebView: WKWebView?
 
    var menu_vc : SideMenuVC!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var listinButton: UIBarButtonItem!
    @IBOutlet weak var home: UIButton!
    @IBOutlet weak var webViewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (UserDefaults.standard.object(forKey: "notifications_switch_value") == nil) {
            defaults.set(true, forKey: "notifications_switch_value")
        }
        let sendNotifications = UserDefaults.standard.object(forKey: "notifications_switch_value") as! Bool
        if (sendNotifications) {
            NewsWorker().doInBackground()
            ChatWorker().doInBackground()
        }
        setupWebView()
        self.progressView.tintColor = UIColor(hexString: "#8B0000")
        self.progressView.transform = CGAffineTransform(scaleX: 1,y: 2)
        password = UserDefaults.standard.object(forKey: "password") as! String
        nickname = UserDefaults.standard.object(forKey: "nickname") as! String
        username = UserDefaults.standard.object(forKey: "username") as! String
        token = UserDefaults.standard.object(forKey: "token") as! String
        listin = UserDefaults.standard.object(forKey: "listin") as! String
        if (listin == "false") {
            listinButton.image = nil
            listinButton.isEnabled = false
        }
        loadSideMenu()
        var url = "https://admin.dicloud.es/"
        URL_INDEX = url
        url = url + "index.asp"
        openIndex(url: url)
        if (URL_MENU != "") {
            loadURLMenu()
            URL_MENU = ""
        }
    }
    
    func loadWebView(urlPath: String) {
         myWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        if let url = URL(string: urlPath) {
            let urlRequest = URLRequest(url: url)
            myWebView.load(urlRequest)
        }
    }
    
    func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        myWebView = WKWebView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        myWebView = WKWebView(frame: view.bounds, configuration: configuration)
        myWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        myWebView.uiDelegate = self
        myWebView.navigationDelegate = self
        webViewView.addSubview(myWebView)
    }
    
    func setSideMenu() {
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as? SideMenuVC
        menu_vc.nicknameTxt = UserDefaults.standard.object(forKey: "nickname") as? String
        menu_vc.usernameTxt = UserDefaults.standard.object(forKey: "fullname") as? String
        menu_vc.companyIDTxt = UserDefaults.standard.object(forKey: "companyID") as? String
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
        menu_vc.setMenuData(userMenu: userMenu)  // set userMenu to side menu
    }
    
    func showURLMenu() {
        loadWebView(urlPath: URL_MENU)
    }
    
    func startProgressView() {
        self.progressView.alpha = 1.0
        progressView.setProgress(Float(myWebView.estimatedProgress), animated: true)
        if (myWebView.estimatedProgress >= 1.0) {
            UIView.animate(withDuration: 0.3, delay: 0.1, options:
                UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.progressView.alpha = 0.0
            }, completion: { (finished:Bool) -> Void in
                self.progressView.progress = 0
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if myWebView.isLoading {
                startProgressView()
            } else {
                self.progressView.layer.sublayers?.forEach { $0.removeAllAnimations() }
            }
        }
    }

    @IBAction func goHome(_ sender: Any) {
        goHomeView = true
        openIndex(url: "https://admin.dicloud.es/index.asp")
    }
    
    func loadURLMenu() {
        loadWebView(urlPath: URL_MENU)
    }
    
    func loadSideMenu() {
        let getMenuURL = "https://app.dicloud.es/getMenu.asp"
        let getMenuParameters = ["password":password,"aliasDb":nickname,"appSource":"Dicloud","user":username, "token": token]
        Alamofire.request(getMenuURL, method: .post, parameters: getMenuParameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let usermenu = try JSONDecoder().decode(Root.self,from: (response.data)!)
                    userMenu = usermenu.usermenu
                    self.setSideMenu()
                }
                catch {
                    print(error)
                }
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func openIndex(url: String) {
        let url = url + "?company=" + nickname
            + "&user=" + username + "&pass=" + password + "&token=" + token + "&l=1"
        loadWebView(urlPath: url)
    }
    
    @IBAction func openListin(_ sender: Any) {
        openIndex(url: URL_INDEX + "/listin.asp")
    }
    
    
    @IBAction func refreshWebView(_ sender: Any) {
        loadWebView(urlPath: (myWebView.url?.absoluteString)!)
    }

    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            showMenu()
        case UISwipeGestureRecognizer.Direction.left:
            close_on_swipe()
        default:
            break
        }
    }
    
    func close_on_swipe() {
        if AppDelegate.menu_bool {
            showMenu()
        } else {
            closeMenu()
        }
    }
    
    func showMenu () {
        self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(menu_vc)
        self.view.addSubview(menu_vc.view)
        AppDelegate.menu_bool = false
    }
    
    func closeMenu() {
        self.menu_vc.view.removeFromSuperview()
        AppDelegate.menu_bool = true
    }

    @IBAction func openMenu(_ sender: Any) {
        if AppDelegate.menu_bool {
            showMenu()
        } else {
            closeMenu()
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension HomeVC: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        view.addSubview(popupWebView!)
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
    }
}

extension HomeVC: WKNavigationDelegate {
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

