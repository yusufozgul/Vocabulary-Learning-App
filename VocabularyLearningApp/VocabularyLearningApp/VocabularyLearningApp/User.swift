//
//  User.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 9.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

class CurrentUserData
{
    public var userEmail: String = ""
    public var userID: String = ""
    public var isSign = false
    private init()
    {
        if UserDefaults.standard.value(forKey: "CurrentUserID") != nil && UserDefaults.standard.value(forKey: "CurrentUserID") as! String != ""
        {
            sign(email: UserDefaults.standard.value(forKey: "CurrentUserMail") as! String, id: UserDefaults.standard.value(forKey: "CurrentUserID") as! String)
        }
    }
    
    static let userData = CurrentUserData()
    
    public func logOut()
    {
        isSign = false
        userEmail = ""
        userID = ""
        UserDefaults.standard.setValue(userEmail, forKey: "CurrentUserMail")
        UserDefaults.standard.setValue(userID, forKey: "CurrentUserID")
    }
    
    public func sign(email: String, id: String)
    {
        userEmail = email
        userID = id
        isSign = true
        UserDefaults.standard.setValue(userEmail, forKey: "CurrentUserMail")
        UserDefaults.standard.setValue(userID, forKey: "CurrentUserID")
    }
}
