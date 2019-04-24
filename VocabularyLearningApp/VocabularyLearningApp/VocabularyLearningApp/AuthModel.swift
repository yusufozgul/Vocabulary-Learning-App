//
//  AuthModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 24.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

private protocol firebaseAuthProtocol: class {
    static func firebaseSignin(userData: userRegisterData)
    static func firebaseSignup(userData: userRegisterData)
}

class FirebaseAuthModel: firebaseAuthProtocol {
    static func firebaseSignin(userData: userRegisterData)
    {
        _ = AuthenticateFirebase.signin(userEmail: userData.userEmail, userPassword: userData.userPassowrd)
    }
    
    static func firebaseSignup(userData: userRegisterData)
    {
        _ = AuthenticateFirebase.signup(userEmail: userData.userEmail, userPassword: userData.userPassowrd)
    }
}
