//
//  FetchWord.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class FetchWords
{
    public init() { }
    
    public func fetch()
    {
        var dbRef: DatabaseReference!
        dbRef = Database.database().reference().child("Words")
        
        let words = dbRef.queryOrderedByKey()
        words.observe(.childAdded, with: { snaphot in
            if let firebaseData = snaphot.value as? [String:String]
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FetchWordData"), object: firebaseData)
            }
        })
    }
}
