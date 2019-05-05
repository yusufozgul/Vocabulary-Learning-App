//
//  addWordModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 24.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

public protocol AddNewWordProtocol
{
    func AddNewWord(data: WordData)
}
class AddNewWord: AddNewWordProtocol
{
    let addWord: AddWordProtocol = AddWord()
    func AddNewWord(data: WordData)
    {
        addWord.AddNewWord(word: data.word, translate: data.translate, sentence: data.sentence, category: data.category)
    }
}
