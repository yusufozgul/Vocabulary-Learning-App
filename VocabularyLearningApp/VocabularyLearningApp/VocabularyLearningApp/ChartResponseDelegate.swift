//
//  ChartResponseDelegate.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 9.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

public protocol ChartResponseDelegate: class
{
    func loadedChart(date: [String], values: [Int])
}
