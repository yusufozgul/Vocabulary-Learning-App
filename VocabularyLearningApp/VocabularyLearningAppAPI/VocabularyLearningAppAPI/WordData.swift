//
//  NewWordModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

struct WordData
{
    var word: String
    var translate: String
    var sentence: String
    var category: String
    var uid: String
}

struct WordPageData
{
    var wordInfo: WordData
    var option1: String
    var option2: String
    var option3: String
    var option4: String
    var correctAnswer: Int
}

struct TestedWordData
{
    var wordInfo: WordData
    var level: String
}

