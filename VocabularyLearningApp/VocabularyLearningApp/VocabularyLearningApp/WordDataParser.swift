//
//  WordDataParser.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 27.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

class WordDataParser
{
    private var wordArray: [WordData] = []
    private var solvedWords = [""]
    func fetchWord()
    {
        if UserDefaults.standard.value(forKey: "correctAnswer") != nil
        {
            solvedWords = UserDefaults.standard.value(forKey: "correctAnswer") as! [String]
        }
        var isMatch: Bool = false
        _ = FetchWords.init().fetch()
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "FetchWordData"), object: nil, queue: OperationQueue.main, using: { (firebaseData) in
            let words = firebaseData.object! as! [String:String]
            isMatch = false
            for word in self.solvedWords
            {
                if word == words["uid"]!
                {
                    isMatch = true
                    break
                }
            }
            if !isMatch
            {
                let word: WordData = WordData(word: words["word"]!, translate: words["translate"]!, sentence: words["sentence"]!, category: words["category"]!, uid: words["uid"]!)
                self.wordArray.append(word)
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "FetchWords"), object: nil)
        })
    }
    
    func getword() -> WordPageData
    {
        if !wordArray.isEmpty
        {
            let randomIndex = Int.random(in: 0 ... (wordArray.count - 1))
            var randomOptions = [0,0,0,0]
            randomOptions[0] = Int.random(in: 0 ... (wordArray.count - 1))
            randomOptions[1] = Int.random(in: 0 ... (wordArray.count - 1))
            randomOptions[2] = Int.random(in: 0 ... (wordArray.count - 1))
            randomOptions[3] = Int.random(in: 0 ... (wordArray.count - 1))
            
            let word = wordArray[randomIndex]
            
            let wordData: WordData = WordData(word: word.word, translate: word.translate, sentence: word.sentence, category: word.category, uid: word.uid)
            
            var wordPageData: WordPageData = WordPageData(wordInfo: wordData,
                                                          option1: wordArray[randomOptions[0]].translate,
                                                          option2: wordArray[randomOptions[1]].translate,
                                                          option3: wordArray[randomOptions[2]].translate,
                                                          option4: wordArray[randomOptions[3]].translate,
                                                          correctAnswer: Int.random(in: 1 ... 4))
            
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
        return WordPageData(wordInfo: WordData(word: "", translate: "", sentence: "", category: "", uid: ""), option1: "", option2: "", option3: "", option4: "", correctAnswer: 0)
    }
    func getArrayCount() -> Int
    {
        return wordArray.count
    }
}
