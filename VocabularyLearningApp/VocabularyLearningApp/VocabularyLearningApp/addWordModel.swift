//
//  addWordModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 24.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

protocol AddNewWordProtocol
{
    func AddNewWord(data: WordData)
}

class AddNewWord: AddNewWordProtocol
{
    func AddNewWord(data: WordData)
    {
        let addWord: AddWord = AddWord()
        addWord.AddNewWord(word: data.word, translate: data.translate, sentence: data.sentence, category: data.category)
    }
}
