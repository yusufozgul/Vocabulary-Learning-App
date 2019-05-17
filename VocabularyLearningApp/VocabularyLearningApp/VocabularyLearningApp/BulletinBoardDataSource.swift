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
    func splashBoard() -> BLTNPageItem
    func signinBoard() -> BLTNBoradSignin
    func signupBoard() -> BLTNBoradSignup
    func accountBoard() -> BLTNPageItem
}

//    Signin - login Boards in BulletinBoard
class BulletinDataSource: BullettinDataSourceProtocol
{
    func splashBoard() -> BLTNPageItem
    {
        let splashBoard = BLTNPageItem(title: NSLocalizedString("SPLASH_BOARD_TITLE", comment: ""))
        splashBoard.image = UIImage(named: "icon")
        splashBoard.descriptionText = NSLocalizedString("SPLASH_BOARD_DESC", comment: "")
        splashBoard.actionButtonTitle = NSLocalizedString("SPLASH_BOARD_SIGNIN", comment: "")
        splashBoard.alternativeButtonTitle = NSLocalizedString("SPLASH_BOARD_SIGNUP", comment: "")
        splashBoard.isDismissable = true
        
        splashBoard.actionHandler = { (item: BLTNActionItem) in
            splashBoard.next = self.signinBoard()
            item.manager?.displayNextItem()
        }
        splashBoard.alternativeHandler = { item in
            splashBoard.next = self.signupBoard()
            item.manager?.displayNextItem()
        }
        return splashBoard
    }
    
    func signinBoard() -> BLTNBoradSignin
    {
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
                
                authModel.firebaseSignin(userData: userData, completion: { (result) in
                    switch result
                    {
                    case .success(_):
                        item.manager?.dismissBulletin()
                    case .failure(let error):
                        signinBoard.descriptionText = error
                        item.manager?.hideActivityIndicator()
                    }
                })
            }
        }
        return signinBoard
    }
    
    func signupBoard() -> BLTNBoradSignup
    {
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
                
                authModel.firebaseSignup(userData: userData, completion: { (result) in
                    switch result
                    {
                    case .success(_):
                        item.manager?.dismissBulletin()
                    case .failure(let error):
                        signupBoard.descriptionText = error
                        item.manager?.hideActivityIndicator()
                        
                    }
                })
            }
        }
        signupBoard.alternativeButtonTitle = NSLocalizedString("SIGNIN", comment: "")
        signupBoard.alternativeHandler = {(item: BLTNActionItem) in
            signupBoard.next = self.signinBoard()
            item.manager?.displayNextItem()
        }
        return signupBoard
    }
    func accountBoard() -> BLTNPageItem
    {
        let authdata = CurrentUserData.userData
        let accountBoard = BLTNPageItem(title: NSLocalizedString("ACCOUNT_BOARD_TITLE", comment: ""))
        accountBoard.image =  UIImage(named: "alertIcon")
        accountBoard.descriptionText = NSLocalizedString("ACCOUNT_BOARD_DESC", comment: "")
        accountBoard.alternativeButtonTitle = NSLocalizedString("ACCOUNT_BOARD_DELETE_DATA", comment: "")
        accountBoard.appearance.alternativeButtonTitleColor = .red
        accountBoard.isDismissable = true
        
        print(authdata.isSign)
        if !authdata.isSign
        {
            accountBoard.appearance.actionButtonColor = UIColor(red: 0.38, green: 0.76, blue: 0.33, alpha: 1.0)
            accountBoard.actionButtonTitle = NSLocalizedString("SIGNIN", comment: "")
        }
        else
        {
            accountBoard.appearance.actionButtonColor = .red
            accountBoard.actionButtonTitle = NSLocalizedString("ACCOUNT_BOARD_LOG_OUT", comment: "")
        }
        
        accountBoard.actionHandler = { (item: BLTNActionItem) in
            UserDefaults.standard.synchronize()
            authdata.logOut()

            item.next = self.splashBoard()
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
