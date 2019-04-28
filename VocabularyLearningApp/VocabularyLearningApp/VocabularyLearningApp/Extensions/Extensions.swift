//
//  Extensions.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 28.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

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
        dateFormatter.dateFormat = "dd-MM-yyyy"
        print(dateFormatter.string(from: now as Date))
        return dateFormatter.string(from: now as Date)
    }
}
