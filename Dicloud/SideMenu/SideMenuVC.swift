//
//  SideMenuVC.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 6/10/19.
//  Copyright © 2019 Queralt Sosa Mompel. All rights reserved.
//

import UIKit
import Alamofire

struct Section {
    var menuOption: String!
    var submenuOptions: [String]!
    var expanded: Bool!
    
    init(menuOption: String, submenuOptions: [String], expanded: Bool) {
        self.menuOption = menuOption
        self.submenuOptions = submenuOptions
        self.expanded = expanded
    }
    
    init(menuOption: String, expanded: Bool) {
        self.menuOption = menuOption
        self.expanded = expanded
    }
}

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class SideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {
    
    @IBOutlet weak var companyLogo: UIImageView!
    var expanded: Bool = false
    @IBOutlet weak var myTableView: UITableView!
    var sections = [Section] ()
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var username: UILabel!
    
    var nicknameTxt : String?
    var usernameTxt: String?
    var companyIDTxt: String?
    var userMenu : [UserMenu]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.tableFooterView = UIView()
        nickname.text = nicknameTxt
        username.text = usernameTxt
        setCompanyLogo()
    }
    
    func setCompanyLogo() {
        let companyPhotoURL = "https://admin.dicloud.es/files/logos/"
        var logoPath = companyPhotoURL + "Logo_" + companyIDTxt! + "_1.gif"
        var urlLogo = URL(string: logoPath)
        var data = try? Data(contentsOf: urlLogo!)
        
        if data != nil {
            setImage(data: data!)
        } else {
            logoPath = companyPhotoURL + "Logo_0_1.gif" // by default, Disoft logo
            urlLogo = URL(string: logoPath)
            data = try? Data(contentsOf: urlLogo!)
            setImage(data: data!)
        }
    }
    
    func setImage(data: Data) {
        let image = UIImage(data: data)
        self.companyLogo.image = image
        self.companyLogo.contentMode = .scaleAspectFit
        self.companyLogo.layer.borderWidth = 1
        self.companyLogo.layer.borderColor = UIColor.white.cgColor
        self.companyLogo.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].submenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].menuOption, section: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = sections[indexPath.section].submenuOptions[indexPath.row]
        return cell
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        expanded = sections[section].expanded
        myTableView.reloadSections(IndexSet(integersIn: section...section), with: .automatic)
        myTableView.beginUpdates()
        
        if (sections[section].menuOption == "Settings") {
            self.performSegue(withIdentifier: "settingsSegue", sender: self)
        } else if (sections[section].menuOption == "Salir") {
            logout()
        }
        for i in 0 ..< sections[section].submenuOptions.count {
            myTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        myTableView.endUpdates()
    }
    
    func closeMenu() {
        self.view.removeFromSuperview()
        AppDelegate.menu_bool = true
    }
    
    func goURLItem(item: String) {
        for menu in userMenu {
            if (menu.submenu == item) {
                URL_MENU = "\(URL_INDEX)\(menu.url)"
                closeMenu()
                webView.load(URLRequest(url:(URL(string: URL_MENU)!)))
            }
        }
    }
    
    func closeSession() {
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        self.performSegue(withIdentifier: "backToLoginSegue", sender: self)
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    func logout() {
        let logoutAlert = UIAlertController(title: "¿Cerrar sesión?", message: "Dejarás de recibir notificaciones", preferredStyle: UIAlertController.Style.alert)
        logoutAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            self.closeSession()
        }))
        logoutAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(logoutAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        let currentItem = currentCell.textLabel!.text
        goURLItem(item: currentItem!)
    }
    
    func setMenuData(userMenu : [UserMenu]) {
        self.userMenu = userMenu
        var subMenuTitle = userMenu[0].menu
        var allSubmenus = [String]()
        for submenu in userMenu {
            if (submenu.menu == subMenuTitle) {
                allSubmenus.append(submenu.submenu)
            } else {
                sections.append(Section(menuOption: subMenuTitle, submenuOptions: allSubmenus, expanded: false))
                allSubmenus.removeAll()
                allSubmenus.append(submenu.submenu)
                subMenuTitle = submenu.menu
            }
        }
        sections.append(Section(menuOption: "Settings", submenuOptions: [], expanded: false))
        sections.append(Section(menuOption: "Salir", submenuOptions: [], expanded: false))
    }
}
