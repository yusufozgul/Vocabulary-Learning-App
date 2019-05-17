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
    private init() { }
    
    static let userData = CurrentUserData()
    
    public func logOut()
    {
        isSign = false
        userEmail = ""
        userID = ""
    }
    
    public func sign(email: String, id: String)
    {
        userEmail = email
        userID = id
        isSign = true
    }
}
