//
//  AddWord.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class AddWord
{
    public init() { }
    
    public func AddNewWord(word: String, translate: String, sentence: String, category: String)
    {
        var dbRef: DatabaseReference!
        dbRef = Database.database().reference()
        let uid = NSUUID().uuidString
        
        dbRef.child("Words").child(uid).setValue(["word": word, "translate": translate, "sentence": sentence, "category": category, "uid": uid]) { (errorDB, DBRef) in
            if errorDB != nil
            {
                print(errorDB!.localizedDescription)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FireBaseMessage"), object: errorDB!.localizedDescription)
            }
            else
            {
                print(DBRef)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FireBaseMessage"), object: true)
            }
        }
    }
}

