//
//  DeleteUserData.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 9.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class DeleteUserData
{
    public init() { }
    public func deleteData(userID: String) // Kullanıcıya ait olan veriler silinir.
    {
        var dbRef: DatabaseReference!
        dbRef = Database.database().reference().child(FirebaseChilds.UserData.rawValue).child(userID)
        dbRef.removeValue()
    }
}



