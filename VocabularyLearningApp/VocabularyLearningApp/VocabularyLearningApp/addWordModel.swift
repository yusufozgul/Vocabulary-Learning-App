//
//  addWordModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 24.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI


/*
 Yeni kelime ekleme modeli
 Kelime bilgileri gönderilir. Belirli kontroller yapılıp uygunluk durumunda Firebase'e eklenir.
 */
public protocol AddNewWordProtocol
{
    func AddNewWord(data: WordData)
}
class AddNewWord: AddNewWordProtocol
{
    let messageService: MessageViewerProtocol = MessageViewer.messageViewer
    let addWord: AddWordProtocol = AddWord()
    let authdata = UserData.userData
    weak var delegate: AddWordDelegate?
    func AddNewWord(data: WordData)
    {
        authdata.reloadData()
        if authdata.isSign
        {
            addWord.AddNewWord(word: data.word, translate: data.translate, sentence: data.sentence, category: data.category) { (result) in
                switch result {
                case .success(_):
                    self.messageService.succesMessage(title: NSLocalizedString("FIREBASE_SUCCES_TITLE", comment: ""), body: NSLocalizedString("FIREBASE_SUCCES", comment: ""))
                    self.delegate?.addWordResult(result: true)
                case .failure:
                    self.messageService.failMessage(title: NSLocalizedString("FIREBASE_ALERT_TITLE", comment: ""), body: "\(NSLocalizedString("A_ISSUE", comment: "")) \n \(Error.self)")
                    self.delegate?.addWordResult(result: false)
                }
            }
        }
        else
        {
            messageService.failMessage(title: NSLocalizedString("NOT_SIGNIN", comment: ""), body: NSLocalizedString("PLEASE_SIGNIN", comment: ""))
        }
    }
}
