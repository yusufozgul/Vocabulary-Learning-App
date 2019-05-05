//
//  FetchLearnCharts.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 5.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

public protocol FetchLearnChartsProtocol
{
    func learnCharts(completion: @escaping (Result<ChartResponse>) -> Void)
    func fetchChilds()
}

public class FetchLearnCharts: FetchLearnChartsProtocol
{
    public var correctArray: [Int] = []
    public var wrongArray: [Int] = []
    public var childs: [String] = []
    var dbRef: DatabaseReference!
    
    public init() {}
    
    public func fetchChilds()
    {
        var count = 0
        var current = 0
        childs.removeAll()
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            dbRef = Database.database().reference().child("UserData").child(currentUserId[1]).child("LearnedWords")
            let dataBase = dbRef.queryOrderedByKey()
            dataBase.observe(.value, with: { snapshot in
                
                if let result = snapshot.children.allObjects as? [DataSnapshot]
                {
                    for child in result
                    {
                        let orderID = child.key
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let firDate = dateFormatter.date(from: orderID)!
                        let nowDate = dateFormatter.date(from: Date().addCurrentDate(value: -1, byAdding: "month"))
                        
                        if firDate >= nowDate!
                        {
                            self.childs.append(child.key)
                            count += 1
                            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2 , execute: // bekletme sebebi tüm veriler geldikten sonra notification atmasını sağlamak.
                                {
                                    current += 1
                                    if current == count
                                    {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchedChart"), object: nil)
                                    }
                            })
                        }
                    }
                }
            })
        }
    }
 
    public func learnCharts(completion: @escaping (Result<ChartResponse>) -> Void)
    {
        if let currentUserId: [String] = UserDefaults.standard.object(forKey: "currentUser") as? [String]
        {
            fetchChilds()
            NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fetchedChart"), object: nil, queue: OperationQueue.main, using: { (_) in

                for child in self.childs
                {
                    self.dbRef = Database.database().reference().child("UserData").child(currentUserId[1]).child("LearnedWords").child(child)
                    let correctRef = self.dbRef.child("Correct").queryOrderedByKey()
                    let wrongRef = self.dbRef.child("Wrong").queryOrderedByKey()
                    correctRef.observe(.value, with: { (snaphot) in
                        self.correctArray.append(Int(snaphot.childrenCount))
                    })
                    wrongRef.observe(.value, with: { (snaphot) in
                        self.wrongArray.append(Int(snaphot.childrenCount))
                    })
                    if child == self.childs.last
                    {
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2 , execute: // bekletme sebebi tüm veriler geldikten sonra notification atmasını sağlamak.
                        {
                            let chartResponse = ChartResponse(correct: self.correctArray, wrong: self.wrongArray, date: self.childs)
                            completion(.success(chartResponse))
                        })
                    }
                }
            })
        }
    }
}