//
//  FetchWord.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Firebase'den kelime çeker ve parse edip gönderir.

public protocol fetchServiceProtocol
{
    func fetchAllWord(completion: @escaping (Result<FetchWordResponse>) -> Void)
    func fetchTestWord(completion: @escaping (Result<FetchTestWordReponse>) -> Void)
    func fetchChilds()
}

public class FetchWords: fetchServiceProtocol
{
    var dbRef: DatabaseReference!
    var wordDbRef: DatabaseReference!
    public var childs: [String] = []
    
    public static let fetchWords = FetchWords()
    private init() { }
    
    public func fetchAllWord(completion: @escaping (Result<FetchWordResponse>) -> Void)
    {
        var count = 0
        var current = 0
        var dataArray: FetchWordResponse = FetchWordResponse(results: [])
        dataArray.results.removeAll()
        dbRef = Database.database().reference().child("Words")
        
        let words = dbRef.queryOrderedByKey()
        words.observe(.childAdded, with: { snaphot in
            if let firebaseData = snaphot.value as? [String:String]
            {
                let wordData: WordData = WordData(word: firebaseData["word"]!, translate: firebaseData["translate"]!, sentence: firebaseData["sentence"]!, category: firebaseData["category"]!, uid: firebaseData["uid"]!)
                count += 1
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2 , execute:
                    {
                        current += 1
                        dataArray.results.append(wordData)
                        if current == count
                        {
                            
                            completion(.success(dataArray))
                        }
                })
            }
            else
            {
                completion(.failure)
            }
        })
    }
    public func fetchChilds()
    {
        var count = 0
        var current = 0
        childs.removeAll()
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            wordDbRef = Database.database().reference().child("UserData").child(currentUserId[1]).child("TestableWords")
            let testRef = wordDbRef.queryOrderedByKey()
            testRef.observe(.value, with: { snapshot in
                
                if let result = snapshot.children.allObjects as? [DataSnapshot]
                {
                    for child in result
                    {
                        let orderID = child.key
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let date = dateFormatter.date(from: orderID)!
                        
                        if date <= NSDate() as Date
                        {
                            self.childs.append(child.key)
                            count += 1
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2 , execute:
                                {
                                    current += 1
                                    if current == count
                                    {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchedChild"), object: nil)
                                    }
                            })
                        }
                    }
                }
            })
        }
    }
    
    public func fetchTestWord(completion: @escaping (Result<FetchTestWordReponse>) -> Void)
    {
        fetchChilds()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fetchedChild"), object: nil, queue: OperationQueue.main, using: { (_) in
            var count = 0
            var current = 0
            
            let wordDetail: WordData = WordData(word: "", translate: "", sentence: "", category: "", uid: "")
            var testableWordData: TestedWordData = TestedWordData(word: wordDetail, level: "")
            
            var testableWords: FetchTestWordReponse = FetchTestWordReponse(results: [])
            
            if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
            {
                for child in self.childs
                {
                    self.dbRef = Database.database().reference().child("UserData").child(currentUserId[1]).child("TestableWords").child(child)
                    let testRef = self.dbRef.queryOrderedByKey()
                    testRef.observe(.childAdded, with: { snaphot in
                        if let firebaseData = snaphot.value! as? [String:String]
                        {
                            testableWordData.word.word = firebaseData["word"]!
                            testableWordData.word.translate = firebaseData["translate"]!
                            testableWordData.word.sentence = firebaseData["sentence"]!
                            testableWordData.word.category = firebaseData["category"]!
                            testableWordData.word.uid = firebaseData["uid"]!
                            testableWordData.level = firebaseData["level"]!
                            
                            testableWords.results.append(testableWordData)
                            count += 1
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2 , execute:
                                {
                                    current += 1
                                    if current == count
                                    {
                                        completion(.success(testableWords))
                                    }
                            })
                        }
                        else
                        {
                            completion(.failure)
                        }
                    })
                }
            }
            else
            {
                completion(.failure)
            }
        })
    }
}
