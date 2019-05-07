//
//  MessageViewer.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 7.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import SwiftMessages

public class MessageViewer
{
    private init() { }
    static let messageViewer = MessageViewer()
    let messageView = MessageView.viewFromNib(layout: .cardView)
    
    func succesMessage(title: String, body: String)
    {
        messageView.configureTheme(.success)
        messageView.button?.isHidden = true
        messageView.configureContent(title: title, body: body)
        messageView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        messageView.layer.cornerRadius = 10
        SwiftMessages.show(view: messageView)
    }
    func failMessage(title: String, body: String)
    {
        messageView.configureTheme(.error)
        messageView.button?.isHidden = true
        messageView.configureContent(title: title, body: body)
        messageView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        messageView.layer.cornerRadius = 10
        SwiftMessages.show(view: messageView)
    }
    func info(title: String, body: String)
    {
        messageView.configureTheme(.info)
        messageView.button?.isHidden = true
        messageView.configureContent(title: title, body: body)
        messageView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        messageView.layer.cornerRadius = 10
        SwiftMessages.show(view: messageView)
    }
    
}
