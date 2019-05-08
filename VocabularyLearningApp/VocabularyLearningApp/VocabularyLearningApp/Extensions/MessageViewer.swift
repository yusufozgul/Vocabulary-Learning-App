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
    func infoView(title: String, body: String)
    {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: NSLocalizedString("OKAY", comment: "")) { _ in
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        SwiftMessages.show(config: config, view: messageView)
    }
}
