//
//  User.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 9.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

class UserData
{
    public var userEmail: String = ""
    public var userID: String = ""
    public var isSign = false
    private init() { reloadData() }
    
    static let userData = UserData()
    public func reloadData()
    {
        if let data: [String] = (UserDefaults.standard.object(forKey: "currentUser") as? [String])
        {
            userEmail = data[0]
            userID = data[1]
            isSign = true
        }
        else
        {
            isSign = false
            userEmail = ""
            userID = ""
        }
    }
}
