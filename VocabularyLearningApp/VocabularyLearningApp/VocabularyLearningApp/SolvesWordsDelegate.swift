//
//  SolvesWordsDelegate.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 17.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

public protocol SolvedWordDelegate: class
{
    func getSolved(solvedArray: [String])
}
