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
    weak var delegate: AddWordDelegate?
    func AddNewWord(data: WordData)
    {
        addWord.AddNewWord(word: data.word, translate: data.translate, sentence: data.sentence, category: data.category) { (result) in
            switch result {
            case .success(_):
                MessageViewer.messageViewer.succesMessage(title: NSLocalizedString("FIREBASE_SUCCES_TITLE", comment: ""), body: NSLocalizedString("FIREBASE_SUCCES", comment: ""))
                self.delegate?.addWordResult(result: true)
            case .failure:
                MessageViewer.messageViewer.failMessage(title: NSLocalizedString("FIREBASE_ALERT_TITLE", comment: ""), body: "\(NSLocalizedString("A_ISSUE", comment: "")) \n \(Error.self)")
                self.delegate?.addWordResult(result: false)
            }
        }
    }
}
