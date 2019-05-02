//
//  NewWordModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 23.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

// Kelime verileri yapıları. Gereken sayfaya göre oluşturulur.
public struct WordData
{
    public var word: String
    public var translate: String
    public var sentence: String
    public var category: String
    public var uid: String
}

public struct WordPageData
{
    public var wordInfo: WordData
    public var option1: String
    public var option2: String
    public var option3: String
    public var option4: String
    public var correctAnswer: Int
}
public struct WordTestPageData
{
    public var wordPage: WordPageData
    public var level: String
}

public struct TestedWordData
{
    public var word: WordData
    public var level: String
}

