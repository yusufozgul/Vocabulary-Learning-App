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
    public init() { }
    
    public func saveProgress(day: String, correctData: [String], wrongData: [String])
    {
        var dbRef: DatabaseReference!
        dbRef = Database.database().reference()
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            dbRef.child("UserData").child(currentUserId[1]).child(String(describing: day)).setValue(["Coreect": correctData, "Wrong": wrongData]) { (errorDB, DBRef) in
                if errorDB != nil
                {
                    print(errorDB?.localizedDescription as Any)
                    //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FireBaseMessage"), object: errorDB!.localizedDescription)
                }
                else
                {
                    
                    //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FireBaseMessage"), object: true)
                }
        }
        }
    }
}
