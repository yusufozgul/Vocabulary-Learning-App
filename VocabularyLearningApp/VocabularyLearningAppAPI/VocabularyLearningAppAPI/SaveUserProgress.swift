//
//  SaveUserProgress.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class SaveUserProgress
{
    var dbRef: DatabaseReference!
    public init() { }
    
    public func saveProgress(child: String, day: String, correctData: [String], wrongData: [String], solvedWords: [String])
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            dbRef = Database.database().reference().child("UserData").child(currentUserId[1])
            dbRef.child(child).child(String(describing: day)).setValue(["Correct": correctData, "Wrong": wrongData]) { (errorDB, DBRef) in
                if errorDB != nil
                {
                    print("FireBase Save Error")
                }
            }
        }
    }
    public func saveTestedProgress(askDay: String, level: String, word: String, translate: String, sentence: String, category: String, id: String)
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            dbRef = Database.database().reference().child("UserData").child(currentUserId[1])
            
            print(String(describing: askDay))            
            
            dbRef.child("TestableWords").child(String(describing: askDay)).child(id).setValue(["word": word, "translate": translate, "sentence": sentence, "category": category, "uid": id, "level": level]) { (errorDB, DBRef) in
                if errorDB != nil
                {
                    print("FireBase Save Error")
                }
            }
        }
    }
}
