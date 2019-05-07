//
//  DeleteTestWord.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 2.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

public protocol FireBaseDeleteProtocol
{
    func deteleteChil(userID: String, uid: String)
}
public class FireBaseDelete: FireBaseDeleteProtocol
{
    //  Firebase'den test edilmiş kelimeyi siler.
    let firebaseService = FetchWords.fetchWords
    var dbRef: DatabaseReference!
    public init() {}
    public func deteleteChil(userID: String, uid: String)
    {
        for child in firebaseService.childs
        {
            dbRef = Database.database().reference().child("UserData").child(userID).child("TestableWords").child(child).child(uid)
            dbRef.removeValue()
        }
    }
}
