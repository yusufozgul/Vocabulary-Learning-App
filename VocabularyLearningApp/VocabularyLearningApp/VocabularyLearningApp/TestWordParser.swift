//
//  TestWordParser.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 7.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

protocol TestWordParserProtocol
{
    var testArray: [TestedWordData] { get set }
    
    func fetchedTestWord()
    func getTestWord() -> WordTestPageData
    func deleteTest(deleteID: String)
    func getTestArrayCount() -> Int
}

// API'dan gelen kelimeleri uygun şartlara göre parse eden singleton kullanılan static bir sınıf.
class TestWordParser: TestWordParserProtocol
{
    weak var fetchedDelegate: FetchedDelegate?
    internal var testArray: [TestedWordData] = [] // Test edilecek kelime dizisi
    let learnWordService: LearnWordParserProtocol = LearnWordParser.parser
    let firebaseService: fetchServiceProtocol = FetchWords.fetchWords // Firebase service
    let authdata = CurrentUserData.userData
    let messageService: MessageViewerProtocol = MessageViewer.messageViewer
    
    static let parser = TestWordParser() // Singleton sağlamak için kendi nesnesini oluşturması.
    private init() { }
    
    func fetchedTestWord() // Test edilecek kelimelerin çekilmesi
    {
        if authdata.isSign
        {
            firebaseService.fetchTestWord(userID: authdata.userID) { (result) in
                switch result {
                case .success(let value):
                    let wordInfo: WordData = WordData(word: "", translate: "", sentence: "", category: "", uid: "")
                    var word: TestedWordData = TestedWordData(word: wordInfo, level: 0)
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
                    self.fetchedDelegate?.fetched()
                case .failure(_):
                    self.messageService.failMessage(title: NSLocalizedString("ALERT_TITLE", comment: ""), body: NSLocalizedString("FAIL_FETCHWORD", comment: ""))
                }
            }
        }
        else
        { messageService.failMessage(title: NSLocalizedString("NOT_SIGNIN", comment: ""), body: NSLocalizedString("PLEASE_SIGNIN_FOR_TEST", comment: "")) }
    }
    
    func getTestWord() -> WordTestPageData // Random test edilecek kelime sayfası oluşturup gönderir.
    {
        if !testArray.isEmpty
        {
            let randomIndex = Int.random(in: 0 ... (testArray.count - 1))
            var randomOptions = [0,0,0,0]
            
            repeat
            {
                randomOptions[0] = Int.random(in: 0 ... (learnWordService.wordArray.count - 1))
                randomOptions[1] = Int.random(in: 0 ... (learnWordService.wordArray.count - 1))
                randomOptions[2] = Int.random(in: 0 ... (learnWordService.wordArray.count - 1))
                randomOptions[3] = Int.random(in: 0 ... (learnWordService.wordArray.count - 1))
            } while(randomIndex == randomOptions[0] || randomIndex == randomOptions[1] || randomIndex == randomOptions[2] || randomIndex == randomOptions[3])
            
            let word = testArray[randomIndex]
            
            let wordData: WordData = WordData(word: word.word.word, translate: word.word.translate, sentence: word.word.sentence, category: word.word.category, uid: word.word.uid)
            
            let wordPageData: WordPageData = WordPageData(wordInfo: wordData,
                                                          option1: learnWordService.wordArray[randomOptions[0]].translate,
                                                          option2: learnWordService.wordArray[randomOptions[1]].translate,
                                                          option3: learnWordService.wordArray[randomOptions[2]].translate,
                                                          option4: learnWordService.wordArray[randomOptions[3]].translate,
                                                          correctAnswer: Int.random(in: 1 ... 4))
            
            var wordTestPageData: WordTestPageData = WordTestPageData(wordPage: wordPageData, level: testArray[randomIndex].level)
            
            switch wordTestPageData.wordPage.correctAnswer
            {
            case 1:
                wordTestPageData.wordPage.option1 = word.word.translate
            case 2:
                wordTestPageData.wordPage.option2 = word.word.translate
            case 3:
                wordTestPageData.wordPage.option3 = word.word.translate
            case 4:
                wordTestPageData.wordPage.option4 = word.word.translate
            default:
                break
            }
            return wordTestPageData
        }
        let wordData = WordPageData(wordInfo: WordData(word: "", translate: "", sentence: "", category: "", uid: ""), option1: "", option2: "", option3: "", option4: "", correctAnswer: 0)
        return WordTestPageData(wordPage: wordData, level: 0)
    }

    func deleteTest(deleteID: String) // Test edilen kelime bulunup silinir.
    {
        var index = 0
        for word in testArray
        {
            if word.word.uid == deleteID
            {
                testArray.remove(at: index)
                break
            }
            index += 1
        }
        if getTestArrayCount() == 0
        {
            messageService.failMessage(title: NSLocalizedString("ALERT_TITLE", comment: ""), body: NSLocalizedString("EMPTY_TEST_WORD", comment: ""))
        }
    }
//    Öğrenilecek ve test edilecek kaç kelime olduğunu döndürür
    func getTestArrayCount() -> Int
    {
        return testArray.count
    }
}
