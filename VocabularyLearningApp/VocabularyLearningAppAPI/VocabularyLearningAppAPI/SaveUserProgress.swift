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
    public func saveTestedProgress(child: String, askDay: String, word: String, level: Int)
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            dbRef = Database.database().reference().child("UserData").child(currentUserId[1])
            
            dbRef.child(child).child(String(describing: askDay)).child(word).setValue(["WordID": word, "level": level]) { (errorDB, DBRef) in
                if errorDB != nil
                {
                    print("FireBase Save Error")
                }
            }
        }
    }
}
