//
//  FetchLearnCharts.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 5.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import FirebaseDatabase

public protocol FetchUserChartsProtocol
{
    func learnCharts(userID: String, timeInterval: String, timeValue: Int, completion: @escaping (Result<ChartResponse>) -> Void)
    func fetchChilds(userID: String, interval: String, intervalValue: Int)
}

public class FetchUserCharts: FetchUserChartsProtocol
{
    public var correctCount: [Int] = []
    public var childs: [String] = []
    var dbRef: DatabaseReference!
    
    public init() {}
    
    public func fetchChilds(userID: String, interval: String, intervalValue: Int) // Gönderilen tarih aralığına göre klasör başlıkları çekilir.
    {
        var count = 0
        var current = 0
        childs.removeAll()
        let addedDate = Date().addCurrentDate(value: -intervalValue, byAdding: interval)

        dbRef = Database.database().reference().child(FirebaseChilds.UserData.rawValue).child(userID).child(FirebaseChilds.Completed.rawValue)
        let dataBase = dbRef.queryOrderedByKey()
        dataBase.observe(.value, with: { snapshot in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot]
            {
                for child in result
                {
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
 
    public func learnCharts(userID: String, timeInterval: String, timeValue: Int, completion: @escaping (Result<ChartResponse>) -> Void) // Tarih aralığına göre klasör isimlerinden veriler çekilir.
    {
        var chartResponse: ChartResponse = ChartResponse(correct: [], date: [])
        self.correctCount.removeAll()
        self.childs.removeAll()
        chartResponse.correctArray.removeAll()
        chartResponse.date.removeAll()
        var firstNotif = true
        
        fetchChilds(userID: userID, interval: timeInterval, intervalValue: timeValue)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "fetchedChart"), object: nil, queue: OperationQueue.main, using: { (_) in
            
            if firstNotif
            {
                firstNotif = false
                self.dbRef = Database.database().reference().child(FirebaseChilds.UserData.rawValue).child(userID).child(FirebaseChilds.Completed.rawValue)
                
                if self.childs.count == 0
                {
                    completion(.failure(""))
                }
                for child in self.childs
                {
                    let chartRef = self.dbRef.child(child).queryOrderedByKey()
                    chartRef.observe(.value, with: { (snaphot) in
                        
                        let chilCount: Int = Int(snaphot.childrenCount)
                        self.correctCount.append(chilCount)
                        
                        if child == self.childs.last
                        {
                            chartResponse.correctArray = self.correctCount
                            chartResponse.date = self.childs
                            
                            completion(.success(chartResponse))
                        }
                    })
                }
            }
            
        })
    }
}
