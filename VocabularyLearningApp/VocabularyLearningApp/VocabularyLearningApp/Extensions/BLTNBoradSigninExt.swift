//
//  BulletinPageTextField.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 27.02.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit
import BLTNBoard

class BLTNBoradSignin: BLTNPageItem
{
//    Giriş yapma kartı oluşturulması
    @objc public var userMail: UITextField!
    @objc public var userPassword: UITextField!
    
    let visibilityButton = UIButton(type: .custom)
    
    @objc public var userMailHandler: ((BLTNActionItem, String?) -> Void)? = nil
    @objc public var userPassWordHAndler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        userMail = interfaceBuilder.makeTextField(placeholder: NSLocalizedString("USER_EMAIL", comment: ""), returnKey: .done, delegate: self)
        userPassword = interfaceBuilder.makeTextField(placeholder: NSLocalizedString("USER_PASSWORD", comment: ""), returnKey: .done, delegate: self)
        
//        Password hider  ------ Add extension?
        visibilityButton.setImage(UIImage(named: "visibility_on"), for: .normal)
        visibilityButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        visibilityButton.frame = CGRect(x: CGFloat(userPassword.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        visibilityButton.addTarget(self, action: #selector(changer), for: .touchUpInside)
        userMail.keyboardType = .emailAddress
        userPassword.rightView = visibilityButton
        userPassword.rightViewMode = .always
        userPassword.isSecureTextEntry = true
        
        return [userMail, userPassword]
    }
    @objc func changer()
    {
        userPassword.isSecureTextEntry = !userPassword.isSecureTextEntry
        if userPassword.isSecureTextEntry
        { visibilityButton.setImage(UIImage(named: "visibility_on"), for: .normal) }
        else
        { visibilityButton.setImage(UIImage(named: "visibility_off"), for: .normal) }
    }
    
    override func tearDown()
    {
        super.tearDown()
        userMail?.delegate = nil
        userPassword?.delegate = nil
    }
    override func actionButtonTapped(sender: UIButton) {
        userMail.resignFirstResponder()
        userPassword.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }
}
extension BLTNBoradSignin: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if textField.text != "" && textField.text != nil
        {
            userMailHandler?(self, userMail.text)
            userPassWordHAndler?(self, userPassword.text)
        }
//     Text issue alert
        else
        {
            descriptionLabel!.textColor = .red
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            descriptionText = NSLocalizedString("PLEASE_WRITE_SOMETHING", comment: "")
        }
    }
    //    Press to return dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //      Text edit alert remove
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        descriptionLabel?.text = nil
        descriptionLabel!.textColor = .black
        descriptionText = NSLocalizedString("SIGNIN_DESC", comment: "")
    }
}

