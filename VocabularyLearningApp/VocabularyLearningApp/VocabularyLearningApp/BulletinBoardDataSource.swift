//
//  BullettinBoardDataSource.swift
//  Vois
//
//  Created by Yusuf Özgül on 27.02.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit
import BLTNBoard

protocol BullettinDataSourceProtocol
{
    static func splashBoard() -> BLTNPageItem
    static func signinBoard() -> BLTNBoradSignin
    static func signupBoard() -> BLTNBoradSignup
    static func accountBoard() -> BLTNPageItem
}

//    Signin - login Boards in BulletinBoard
enum BulletinDataSource: BullettinDataSourceProtocol
{
    static func splashBoard() -> BLTNPageItem
    {
        let splashBoard = BLTNPageItem(title: NSLocalizedString("SPLASH_BOARD_TITLE", comment: ""))
        splashBoard.image = UIImage(named: "icon")
        splashBoard.descriptionText = NSLocalizedString("SPLASH_BOARD_DESC", comment: "")
        splashBoard.actionButtonTitle = NSLocalizedString("SPLASH_BOARD_SIGNIN", comment: "")
        splashBoard.alternativeButtonTitle = NSLocalizedString("SPLASH_BOARD_SIGNUP", comment: "")
        splashBoard.isDismissable = true
        
        splashBoard.actionHandler = { (item: BLTNActionItem) in
            splashBoard.next = signinBoard()
            item.manager?.displayNextItem()
        }
        splashBoard.alternativeHandler = { item in
            splashBoard.next = signupBoard()
            item.manager?.displayNextItem()
        }
        return splashBoard
    }
    
    static func signinBoard() -> BLTNBoradSignin
    {
        let authdata = UserData.userData
        var userData = userRegisterData.init(userEmail: "", userPassowrd: "")
        let signinBoard = BLTNBoradSignin(title: NSLocalizedString("SIGNIN", comment: ""))
        signinBoard.descriptionText = NSLocalizedString("SIGNIN_DESC", comment: "")
        
        signinBoard.userMailHandler = { (item, text) in
            userData.userEmail = text!
        }
        signinBoard.userPassWordHAndler = { (item, text) in
            userData.userPassowrd = text!
        }
        signinBoard.actionButtonTitle = NSLocalizedString("SIGNIN", comment: "")
        signinBoard.actionHandler = {(item: BLTNActionItem) in

//            Control Entered İnformation
            if (userData.userEmail != "") && (userData.userPassowrd != "")
            {
                item.manager?.displayActivityIndicator()
                let authModel: firebaseAuthProtocol = FirebaseAuthModel()
                authModel.firebaseSignin(userData: userData)
                
                NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fireBaseMessage"), object: nil, queue: OperationQueue.main, using: { (firebaseMessage) in
                    if String(describing: firebaseMessage.object!) != "succes"
                    {
                        signinBoard.descriptionText = String(describing: firebaseMessage.object!)
                        item.manager?.hideActivityIndicator()
                    }
                    else
                    {
                        item.manager?.dismissBulletin()
                        authdata.reloadData()
                    }
                })
            }
        }
        return signinBoard
    }
    
    static func signupBoard() -> BLTNBoradSignup
    {
        let authdata = UserData.userData
        var userData = userRegisterData(userEmail: "", userPassowrd: "")
        
        let signupBoard = BLTNBoradSignup(title: NSLocalizedString("SIGNUP", comment: ""))
        signupBoard.descriptionText = NSLocalizedString("SIGNUP_DESC", comment: "")
        
        signupBoard.userMailHandler = { (item, text) in
            userData.userEmail = text!
        }
        signupBoard.userPassWordHAndler = { (item, text) in
            userData.userPassowrd = text!
        }
        signupBoard.actionButtonTitle = NSLocalizedString("SIGNUP", comment: "")
        signupBoard.actionHandler = {(item: BLTNActionItem) in
  
//            Control Entered İnformation
            if (userData.userEmail != "") && (userData.userEmail != "") && (userData.userPassowrd != "")
            {
                item.manager?.displayActivityIndicator()
                let authModel: firebaseAuthProtocol = FirebaseAuthModel()
                authModel.firebaseSignup(userData: userData)

                NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fireBaseMessage"), object: nil, queue: OperationQueue.main, using: { (firebaseMessage) in
                    if String(describing: firebaseMessage.object!) != "succes"
                    {
                        signupBoard.descriptionText = String(describing: firebaseMessage.object!)
                        item.manager?.hideActivityIndicator()
                    }
                    else
                    {
                        item.manager?.dismissBulletin()
                        authdata.reloadData()
                    }
                })
            }
        }
        signupBoard.alternativeButtonTitle = NSLocalizedString("SIGNIN", comment: "")
        signupBoard.alternativeHandler = {(item: BLTNActionItem) in
            signupBoard.next = signinBoard()
            item.manager?.displayNextItem()
        }
        return signupBoard
    }
    static func accountBoard() -> BLTNPageItem
    {
        let authdata = UserData.userData
        let accountBoard = BLTNPageItem(title: NSLocalizedString("ACCOUNT_BOARD_TITLE", comment: ""))
        accountBoard.image =  UIImage(named: "alertIcon")
        accountBoard.descriptionText = NSLocalizedString("ACCOUNT_BOARD_DESC", comment: "")
        accountBoard.actionButtonTitle = NSLocalizedString("ACCOUNT_BOARD_LOG_OUT", comment: "")
        accountBoard.alternativeButtonTitle = NSLocalizedString("ACCOUNT_BOARD_DELETE_DATA", comment: "")
        accountBoard.appearance.actionButtonColor = .red
        accountBoard.appearance.alternativeButtonTitleColor = .red
        accountBoard.isDismissable = true
        
        if !authdata.isSign
        {
            accountBoard.appearance.actionButtonColor = .green
            accountBoard.actionButtonTitle = NSLocalizedString("SIGNIN", comment: "")
        }
        
        accountBoard.actionHandler = { (item: BLTNActionItem) in
            UserDefaults.standard.removeObject(forKey: "currentUser")
            UserDefaults.standard.synchronize()
            authdata.reloadData()

            item.next = splashBoard()
            item.manager?.displayNextItem()
        }
        var isSecond = false
        accountBoard.alternativeHandler = { item in
            if isSecond
            {
                DeleteUserDataModel().deleteData()
                accountBoard.descriptionText = NSLocalizedString("ACCOUNT_BOARD_DESC", comment: "")
                accountBoard.descriptionLabel?.textColor = .black
            }
            else
            {
                isSecond = true
                accountBoard.alternativeButtonTitle = NSLocalizedString("ARE_YOU_SURE", comment: "")
                accountBoard.descriptionText = NSLocalizedString("DELETE_ACCOUNT_QUESTION", comment: "")
                accountBoard.descriptionLabel?.textColor = .red
            }
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 4, execute: {
                isSecond = false
                accountBoard.alternativeButtonTitle = NSLocalizedString("ACCOUNT_BOARD_DELETE_DATA", comment: "")
                accountBoard.descriptionText = NSLocalizedString("ACCOUNT_BOARD_DESC", comment: "")
                accountBoard.descriptionLabel?.textColor = .black
            })
        }
        return accountBoard
    }
}
