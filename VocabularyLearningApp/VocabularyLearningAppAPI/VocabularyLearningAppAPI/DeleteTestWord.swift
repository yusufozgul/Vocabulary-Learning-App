//
//  DeleteTestWord.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 2.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class FireBaseDelete
{
    //  Firebase'den test edilmiş kelimeyi siler.
    let firebaseService = FetchWords.fetchWords
    var dbRef: DatabaseReference!
    public init() {}
    public func deteleteChil(uid: String)
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            for child in firebaseService.childs
            {
                dbRef = Database.database().reference().child("UserData").child(currentUserId[1]).child("TestableWords").child(child).child(uid)
                dbRef.removeValue()
            }
        }
    }
}
