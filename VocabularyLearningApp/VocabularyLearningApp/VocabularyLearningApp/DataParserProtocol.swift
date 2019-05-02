//
//  DataParserProtocol.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 30.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

protocol DataParserProtocol
{
    var wordArray: [WordData] { get set }
    var testArray: [TestedWordData] { get set }
    
    func fetchedLearnWord()
    func fetchedTestWord()
    func getLearnWord() -> WordPageData
    func getTestWord() -> WordTestPageData
    func getLearnArrayCount() -> Int
    func getTestArrayCount() -> Int
}
