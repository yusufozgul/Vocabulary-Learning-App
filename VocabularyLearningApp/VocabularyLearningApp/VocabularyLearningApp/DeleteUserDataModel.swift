//
//  DeleteUserData.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 9.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

/*
 Test edilen bir kelime veritabanının ilgili yerinden silinir yeni yerine eklenir.
 */
protocol DeleteUserDataProtocol
{
    func deleteData()
}

class DeleteUserDataModel: DeleteUserDataProtocol
{
    let authdata = UserData.userData
    let messageService: MessageViewerProtocol = MessageViewer.messageViewer
    func deleteData()
    {
        if authdata.isSign
        {
            DeleteUserData.init().deleteData(userID: authdata.userID)
        }
        else
        {
            messageService.failMessage(title: NSLocalizedString("NOT_SIGNIN", comment: ""), body: NSLocalizedString("PLEASE_SIGNIN_FOR_DELETE_DATA", comment: ""))
        }
    }
}
