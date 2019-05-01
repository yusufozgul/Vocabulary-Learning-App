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
    var dbRef: DatabaseReference!
    var wordDbRef: DatabaseReference!
    public init() { }
    
    public func fetchLearnWords()
    {
        dbRef = Database.database().reference().child("Words")
        
        let words = dbRef.queryOrderedByKey()
        words.observe(.childAdded, with: { snaphot in
            if let firebaseData = snaphot.value as? [String:String]
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FetchWordData"), object: firebaseData)
            }
        })
    }
    public func fetchTestWords()
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            dbRef = Database.database().reference().child("UserData").child(currentUserId[1]).child("TestWords").child("02-05-2019")
            var testableWordData: [String] = []
            
            let words = dbRef.queryOrderedByKey()
            words.observe(.childAdded, with: { snaphot in
                if let firebaseData = snaphot.value! as? [String:String]
                {
                    testableWordData.append(firebaseData["level"]!)
                    
                    
                    
                    
                    self.wordDbRef = Database.database().reference().child("Words")
                    
                    let testableWords = self.wordDbRef.queryOrdered(byChild: firebaseData["WordID"]!)
                    testableWords.observe(.childAdded, with: { (DataSnapshot) in
                        
                        if let testableWord = DataSnapshot.value as? [String:String]
                        {

                            
                            testableWordData.append(testableWord["word"]!)
                            testableWordData.append(testableWord["sentence"]!)
                            testableWordData.append(testableWord["translate"]!)
                            testableWordData.append(testableWord["category"]!)
                            testableWordData.append(testableWord["uid"]!)
                            
                            
                            
                            
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "testableWordData"), object: testableWordData)
                        }
                        else
                        {
                            print("ERROR")
                        }
                    })
                }
                else
                {
                    print("ERROR")
                }
            })
        }
        
    }
}
