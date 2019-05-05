//
//  AuthModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 24.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

// Firebase giriş ve login kontrolleri model'i
public protocol firebaseAuthProtocol
{
    func firebaseSignin(userData: userRegisterData)
    func firebaseSignup(userData: userRegisterData)
}

class FirebaseAuthModel: firebaseAuthProtocol
{
    let authService: AuthenticateFirebaseProtocol = AuthenticateFirebase()
    func firebaseSignin(userData: userRegisterData)
    {
        authService.signin(userEmail: userData.userEmail, userPassword: userData.userPassowrd)
    }
    
    func firebaseSignup(userData: userRegisterData)
    {
        authService.signup(userEmail: userData.userEmail, userPassword: userData.userPassowrd)
    }
}
