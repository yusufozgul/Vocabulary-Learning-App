//
//  WordDataParser.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 27.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

class LearnWordDataParser: DataParserProtocol
{
    internal var wordArray: [WordData] = []
    internal var testArray: [TestedWordData] = []
    
    func fetchWord()
    {
        FetchWords().fetchLearnWords()
        fetchedLearnWord()
        FetchWords().fetchTestWords()
        fetchedTestDataWord()
    }
    
    func fetchedLearnWord()
    {
        var solvedWords = [""]
        var isMatch: Bool = false
        var count = 0
        var current = 0
        
        if UserDefaults.standard.value(forKey: "SolvedWords") != nil
        {
            solvedWords.removeAll()
            solvedWords = UserDefaults.standard.value(forKey: "correctAnswer") as! [String]
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "FetchWordData"), object: nil, queue: OperationQueue.main, using: { (firebaseData) in
            let words = firebaseData.object! as! [String:String]
            isMatch = false
            for word in solvedWords
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
            count += 1
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2 , execute: {
                current += 1
                if current == count
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "FetchWords"), object: nil)
                }
            })
        })
    }
    func fetchedTestDataWord()
    {
        var count = 0
        var current = 0
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "testableWordData"), object: nil, queue: OperationQueue.main, using: { (firebaseData) in
            
            let words = firebaseData.object! as! [String]
            
            
            print("")
            print(words.count)
            print("")
            
            
//            let testableWord: WordData = WordData(word: word.word, translate: word.translate, sentence: word.sentence, category: word.category, uid: word.uid)
//            let testWord: TestedWordData = TestedWordData(wordInfo: testableWord, level: words["level"]!)
//            self.testArray.append(testWord)
            
            count += 1
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.2 , execute: {
                current += 1
                if current == count
                {
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: "FetchTestWord"), object: nil)
                    print(self.testArray)
                }
            })
        })
    }
    
    func getword() -> WordPageData
    {
        DispatchQueue.main.async
        {
            if UserDefaults.standard.value(forKey: "correctAnswer") != nil
            {
                let correctAnswerArray = UserDefaults.standard.value(forKey: "correctAnswer") as! [String]
                if self.wordArray.count - correctAnswerArray.count < 30
                {
                    self.fetchWord()
                }
            }
        }
        if !wordArray.isEmpty
        {
            let randomIndex = Int.random(in: 0 ... (wordArray.count - 1))
            var randomOptions = [0,0,0,0]
            
            repeat
            {
                randomOptions[0] = Int.random(in: 0 ... (wordArray.count - 1))
                randomOptions[1] = Int.random(in: 0 ... (wordArray.count - 1))
                randomOptions[2] = Int.random(in: 0 ... (wordArray.count - 1))
                randomOptions[3] = Int.random(in: 0 ... (wordArray.count - 1))
            } while(randomIndex == randomOptions[0] || randomIndex == randomOptions[1] || randomIndex == randomOptions[2] || randomIndex == randomOptions[3])
            
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
