//
//  LearnWordParser.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 7.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

protocol LearnWordParserProtocol
{
    var wordArray: [WordData] { get }
    
    func fetchedLearnWord()
    func getLearnWord() -> WordPageData
    func getLearnArrayCount() -> Int
}

// API'dan gelen kelimeleri uygun şartlara göre parse eden singleton kullanılan static bir sınıf.
class LearnWordParser: LearnWordParserProtocol
{
    weak var fetchedDelegate: FetchedDelegate?
    public var solvedWords: [String] = []
    public var wordArray: [WordData] = [] // Sorulacak kelime dizisi
    let firebaseService: fetchServiceProtocol = FetchWords.fetchWords // Firebase service
    let messageService: MessageViewerProtocol = MessageViewer.messageViewer
    
    static let parser = LearnWordParser() // Singleton sağlamak için kendi nesnesini oluşturması.
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
                self.fetchedDelegate?.fetched()
            case .failure:
                self.messageService.failMessage(title: NSLocalizedString("ALERT_TITLE", comment: ""), body: NSLocalizedString("FAIL_FETCHWORD", comment: ""))
            }
        }
    }
    func getLearnWord() -> WordPageData // Random öğrenilecek kelime sayfasını oluşturup gönderir
    {
        if !wordArray.isEmpty
        {
            whilelabel: while true
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
                case 2:
                    wordPageData.option2 = word.translate
                case 3:
                    wordPageData.option3 = word.translate
                case 4:
                    wordPageData.option4 = word.translate
                default:
                    break
                }
                for solvedWord in solvedWords
                {
                    if solvedWord == word.uid
                    { continue whilelabel }
                }
                return wordPageData
            }
        }
        return WordPageData(wordInfo: WordData(word: "", translate: "", sentence: "", category: "", uid: ""), option1: "", option2: "", option3: "", option4: "", correctAnswer: 0)
    }

//    Öğrenilecek ve test edilecek kaç kelime olduğunu döndürür
    func getLearnArrayCount() -> Int
    {
        return wordArray.count
    }
}
