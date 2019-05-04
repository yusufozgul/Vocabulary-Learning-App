//
//  WordDataParser.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 27.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

// API'dan gelen kelimeleri uygun şartlara göre parse eden singleton kullanılan static bir sınıf.

class WordDataParser: DataParserProtocol
{
    internal var wordArray: [WordData] = [] // Sorulacak kelime dizisi
    internal var testArray: [TestedWordData] = [] // Test edilecek kelime dizisi
    let firebaseService: fetchServiceProtocol = FetchWords.fetchWords // Firebase service
    
    static let parser = WordDataParser() // Singleton sağlamak için kendi nesnesini oluşturması.
    private init() { }
    
    func fetchedLearnWord() // Öğrenilcek kelimelerin çekilmesi
    {
        wordArray.removeAll()
        firebaseService.fetchAllWord { result in
            switch result {
            case .success(let value):
                var word: WordData = WordData(word: "", translate: "", sentence: "", category: "", uid: "")
                for result in value.results
                {
                    word.word = result.word
                    word.translate = result.translate
                    word.sentence = result.sentence
                    word.category = result.category
                    word.uid = result.uid
                    self.wordArray.append(word)
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "FetchWords"), object: nil)
            case .failure:
                print("HATAAAAAAAAAAAAAAAAAAAAAAA")
            }
        }
    }
    func fetchedTestWord() // Test edilecek kelimelerin çekilmesi
    {
        firebaseService.fetchTestWord { (result) in
            switch result {
            case .success(let value):
                let wordInfo: WordData = WordData(word: "", translate: "", sentence: "", category: "", uid: "")
                var word: TestedWordData = TestedWordData(word: wordInfo, level: "")
                for result in value.results
                {
                    word.word.word = result.word.word
                    word.word.translate = result.word.translate
                    word.word.sentence = result.word.sentence
                    word.word.category = result.word.category
                    word.word.uid = result.word.uid
                    word.level = result.level
                    self.testArray.append(word)
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "FetchTestWords"), object: nil)
            case .failure(let message):
                NotificationCenter.default.post(name: Notification.Name(rawValue: "FailAlert"), object: message)
            }
        }
    }
    
    func getLearnWord() -> WordPageData // Random öğrenilecek kelime sayfasını oluşturup gönderir
    {
        DispatchQueue.main.async
        {
            if UserDefaults.standard.value(forKey: "correctAnswer") != nil
            {
                let correctAnswerArray = LoadLocalData().loadCorrectAnswers()
                if self.wordArray.count - correctAnswerArray.count < 30
                {
                    self.fetchedLearnWord()
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
    
    func getTestWord() -> WordTestPageData // Random test edilecek kelime sayfası oluşturup gönderir.
    {
        if !testArray.isEmpty
        {
            let randomIndex = Int.random(in: 0 ... (testArray.count - 1))
            var randomOptions = [0,0,0,0]
            
            repeat
            {
                randomOptions[0] = Int.random(in: 0 ... (wordArray.count - 1))
                randomOptions[1] = Int.random(in: 0 ... (wordArray.count - 1))
                randomOptions[2] = Int.random(in: 0 ... (wordArray.count - 1))
                randomOptions[3] = Int.random(in: 0 ... (wordArray.count - 1))
            } while(randomIndex == randomOptions[0] || randomIndex == randomOptions[1] || randomIndex == randomOptions[2] || randomIndex == randomOptions[3])
            
            let word = testArray[randomIndex]
            
            let wordData: WordData = WordData(word: word.word.word, translate: word.word.translate, sentence: word.word.sentence, category: word.word.category, uid: word.word.uid)
            
            
            
            let wordPageData: WordPageData = WordPageData(wordInfo: wordData,
                                                          option1: wordArray[randomOptions[0]].translate,
                                                          option2: wordArray[randomOptions[1]].translate,
                                                          option3: wordArray[randomOptions[2]].translate,
                                                          option4: wordArray[randomOptions[3]].translate,
                                                          correctAnswer: Int.random(in: 1 ... 4))
            
            var wordTestPageData: WordTestPageData = WordTestPageData(wordPage: wordPageData, level: testArray[randomIndex].level)
            
            switch wordTestPageData.wordPage.correctAnswer
            {
            case 1:
                wordTestPageData.wordPage.option1 = word.word.translate
                break
            case 2:
                wordTestPageData.wordPage.option2 = word.word.translate
                break
            case 3:
                wordTestPageData.wordPage.option3 = word.word.translate
                break
            case 4:
                wordTestPageData.wordPage.option4 = word.word.translate
                break
            default:
                break
            }
            return wordTestPageData
        }
        let wordData = WordPageData(wordInfo: WordData(word: "", translate: "", sentence: "", category: "", uid: ""), option1: "", option2: "", option3: "", option4: "", correctAnswer: 0)
        return WordTestPageData(wordPage: wordData, level: "")
        
    }
    
//    Öğrenilecek ve test edilecek kaç kelime olduğunu döndürür
    func getLearnArrayCount() -> Int
    {
        return wordArray.count
    }
    func getTestArrayCount() -> Int
    {
        return testArray.count
    }
}
