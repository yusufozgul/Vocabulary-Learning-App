//
//  ChartResponse.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 5.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

public struct ChartResponse
{
    public var correctArray: [Int]
    public var date: [String]
    
    init(correct: [Int], date: [String])
    {
        self.correctArray = correct
        self.date = date
    }
}
