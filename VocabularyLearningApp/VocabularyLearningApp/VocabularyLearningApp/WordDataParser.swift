//
//  WordDataParser.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 27.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

class WordDataParser
{
    private var wordArray: [WordData] = []
    func fetchWord()
    {
//        Firebase fetch word
    }
    func getword() -> WordPageData
    {
        
        let randomIndex = Int.random(in: 0 ... wordArray.count)
        var randomOptions: [Int] = []
        if !wordArray.isEmpty
        {
            for option in 0 ... 3
            {
                randomOptions[option] = Int.random(in: 0 ... wordArray.count)
            }
            let word = wordArray[randomIndex]
            
            let wordData: WordData = WordData(word: word.word, translate: word.translate, sentence: word.sentence, category: word.category)
            
            var wordPageData: WordPageData = WordPageData(wordInfo: wordData,
                                                          option1: wordArray[randomOptions[0]].translate,
                                                          option2: wordArray[randomOptions[1]].translate,
                                                          option3: wordArray[randomOptions[2]].translate,
                                                          option4: wordArray[randomOptions[3]].translate,
                                                          correctAnswer: Int.random(in: 0 ... 4))
            
            switch wordPageData.correctAnswer
            {
            case 1:
                wordPageData.option1 = word.translate
                break
            case 2:
                wordPageData.option2 = word.translate
                break
            case 3:
                wordPageData.option3 = word.translate
                break
            case 4:
                wordPageData.option4 = word.translate
                break
            default:
                break
            }
            return wordPageData
        }
        return WordPageData(wordInfo: WordData(word: "", translate: "", sentence: "", category: ""), option1: "", option2: "", option3: "", option4: "", correctAnswer: 0)
//        istendiğinde randım kelime verilecek
    }
    func getArrayCount() -> Int
    {
        return wordArray.count
    }
}
