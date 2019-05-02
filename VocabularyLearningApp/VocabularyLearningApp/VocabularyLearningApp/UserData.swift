//
//  UserData.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 17.03.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

// User datas struct. Signin, Signup etc
public struct currentUserData
{
    var userEmail: String?
    var userID: String?
    
    init() {
        if let data: [String] = (UserDefaults.standard.object(forKey: "currentUser") as? [String])
        {
            userEmail = data[0]
            userID = data[1]
        }
        else
        {
            userEmail = ""
            userID = ""
        }
    }
}
public struct userRegisterData
{
    var userEmail:String
    var userPassowrd: String
}

