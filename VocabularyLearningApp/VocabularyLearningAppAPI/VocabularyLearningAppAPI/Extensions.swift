//
//  Extensions.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

//  Sayfa geçişi ve Tarih formatlama için gerekli genişletmeler
extension UIScrollView
{
    func scrollToPage(index: UInt8, animated: Bool)
    {
        let offset: CGPoint = CGPoint(x: CGFloat(index) * frame.size.width, y: 0)
        self.setContentOffset(offset, animated: animated)
        self.contentOffset.x -= self.frame.width
    }
}

extension Date
{
    func currentDate() -> String
    {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: now as Date)
    }
    func addCurrentDate(value: Int, byAdding: String) -> String
    {
        var dateComponent = DateComponents()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        switch byAdding {
        case "month":
            dateComponent.month = value
            break
        case "week":
            dateComponent.day = value
        case "day":
            dateComponent.day = value
            break
        case "year":
            dateComponent.year = value
            break
        default:
            print("Date component error")
            break
        }
        let dateAdding = Calendar.current.date(byAdding: dateComponent, to: Date())
        
        return dateFormatter.string(from: dateAdding! as Date)
    }
    func getMonthDays() -> Int
    {
        let dateComponents = DateComponents()
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    func dateFormatter(date: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)!
    }
}
