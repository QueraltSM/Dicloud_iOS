//
//  kTextFiledPlaceHolder.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 9/10/19.
//  Copyright © 2019 Queralt Sosa Mompel. All rights reserved.
//


import UIKit

enum placeholderDirection: String {
    case placeholderUp = "up"
    case placeholderDown = "down"
    
}
class textfieldDesign: UITextField {
    var enableMaterialPlaceHolder : Bool = true
    var placeholderAttributes = NSDictionary()
    var lblPlaceHolder = UILabel()
    var defaultFont = UIFont()
    var difference: CGFloat = 35.0
    var directionMaterial = placeholderDirection.placeholderUp
    var isUnderLineAvailabe : Bool = true
    var underLine = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Initialize ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Initialize ()
    }
    
    func Initialize(){
        self.clipsToBounds = false
        self.addTarget(self, action: #selector(textfieldDesign.textFieldDidChange), for: .editingChanged)
        self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: true)
        if isUnderLineAvailabe {
            self.setUnderline(color: UIColor.gray)
        }
        defaultFont = self.font!
    }
    
    @IBInspectable var placeHolderColor: UIColor? = UIColor.blue {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder! as String ,
                                                            attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor!])
        }
    }
    
    override internal var placeholder:String?  {
        didSet {}
        willSet {
            let atts  = [NSAttributedString.Key.font: font]
            self.attributedPlaceholder = NSAttributedString(string: newValue!, attributes:atts as [NSAttributedString.Key : Any])
            self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: self.enableMaterialPlaceHolder)
        }
    }
    
    override internal var attributedText:NSAttributedString?  {
        didSet {}
        willSet {
            if (self.placeholder != nil) && (self.text != ""){
                let string = NSString(string : self.placeholder!)
                self.placeholderText(string)
            }
        }
    }
    
    var color : UIColor!
    
    @objc func textFieldDidChange(){
        if self.enableMaterialPlaceHolder {
            if (self.text == nil) || (self.text?.count)! > 0 {
                self.lblPlaceHolder.alpha = 1
                self.attributedPlaceholder = nil
                self.lblPlaceHolder.textColor = self.placeHolderColor
                let fontSize = self.font!.pointSize;
                self.lblPlaceHolder.font = UIFont.init(name: (self.font?.fontName)!, size: fontSize-3)
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {() -> Void in
                if (self.text == nil) || (self.text?.count)! <= 0 {
                    self.lblPlaceHolder.font = self.defaultFont
                    self.lblPlaceHolder.frame = CGRect(x: self.lblPlaceHolder.frame.origin.x, y : 0, width :self.frame.size.width, height : self.frame.size.height)
                } else {
                    if self.directionMaterial == placeholderDirection.placeholderUp {
                        self.lblPlaceHolder.frame = CGRect(x : self.lblPlaceHolder.frame.origin.x, y : -self.difference, width : self.frame.size.width, height : self.frame.size.height)
                        self.setUnderline(color: self.color!)
                    } else {
                        self.lblPlaceHolder.frame = CGRect(x : self.lblPlaceHolder.frame.origin.x, y : self.difference, width : self.frame.size.width, height : self.frame.size.height)
                        self.setUnderline(color: self.color!)
                    }
                    
                }
            }, completion: {(finished: Bool) -> Void in
            })
        }
    }
    
    func setUnderline(color: UIColor) {
        self.color = color
        self.lblPlaceHolder.textColor = color
        self.underLine.backgroundColor = color
        self.underLine.frame = CGRect(x: 0, y: self.frame.size.height-1, width : self.frame.size.width, height : 1)
        self.underLine.clipsToBounds = true
        self.addSubview(self.underLine)
    }
    
    func EnableMaterialPlaceHolder(enableMaterialPlaceHolder: Bool){
        self.enableMaterialPlaceHolder = enableMaterialPlaceHolder
        self.lblPlaceHolder = UILabel()
        self.lblPlaceHolder.frame = CGRect(x: 0, y : 0, width : 0, height :self.frame.size.height)
        self.lblPlaceHolder.font = UIFont.systemFont(ofSize: 10)
        self.lblPlaceHolder.alpha = 0
        self.lblPlaceHolder.clipsToBounds = true
        self.addSubview(self.lblPlaceHolder)
        self.lblPlaceHolder.attributedText = self.attributedPlaceholder
        self.lblPlaceHolder.sizeToFit()
    }
    
    func placeholderText(_ placeholder: NSString){
        let atts  = [NSAttributedString.Key.font: font]
        self.attributedPlaceholder = NSAttributedString(string: placeholder as String , attributes:atts as [NSAttributedString.Key : Any])
        self.EnableMaterialPlaceHolder(enableMaterialPlaceHolder: self.enableMaterialPlaceHolder)
    }
    override func becomeFirstResponder()->(Bool){
        let returnValue = super.becomeFirstResponder()
        return returnValue
    }
    override func resignFirstResponder()->(Bool){
        let returnValue = super.resignFirstResponder()
        return returnValue
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
