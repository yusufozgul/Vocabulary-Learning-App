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
    func learnCharts(userID: String, completion: @escaping (Result<ChartResponse>) -> Void)
    func fetchChilds(userID: String, interval: String, intervalValue: Int)
}

public class FetchLearnCharts: FetchLearnChartsProtocol
{
    public var correctArray: [Int] = []
    public var wrongArray: [Int] = []
    public var childs: [String] = []
    var dbRef: DatabaseReference!
    
    public init() {}
    
    public func fetchChilds(userID: String, interval: String, intervalValue: Int)
    {
        var count = 0
        var current = 0
        childs.removeAll()

        dbRef = Database.database().reference().child("UserData").child(userID).child("Completed")
        let dataBase = dbRef.queryOrderedByKey()
        dataBase.observe(.value, with: { snapshot in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot]
            {
                for child in result
                {
                    let addedDate = Date().addCurrentDate(value: -intervalValue, byAdding: interval)
                    
                    if Date().dateFormatter(date: child.key) >= Date().dateFormatter(date: addedDate)
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
 
    public func learnCharts(userID: String, completion: @escaping (Result<ChartResponse>) -> Void)
    {
        fetchChilds(userID: userID, interval: "", intervalValue: 0)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fetchedChart"), object: nil, queue: OperationQueue.main, using: { (_) in
            
            for child in self.childs
            {
                self.dbRef = Database.database().reference().child("UserData").child(userID).child("Completed").child(child)
                
                let chartRef = self.dbRef.child("Correct").queryOrderedByKey()
                chartRef.observe(.value, with: { (snaphot) in
                    self.correctArray.append(Int(snaphot.childrenCount))
                })

                if child == self.childs.last
                {
                    let chartResponse = ChartResponse(correct: self.correctArray, date: self.childs)
                    completion(.success(chartResponse))
                }
            }
        })
    }
}
