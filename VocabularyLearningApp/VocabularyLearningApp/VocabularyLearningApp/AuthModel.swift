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
    func firebaseSignin(userData: userRegisterData, completion: @escaping (Result<Any>) -> Void)
    func firebaseSignup(userData: userRegisterData, completion: @escaping (Result<Any>) -> Void)
}

class FirebaseAuthModel: firebaseAuthProtocol
{
    let authData = CurrentUserData.userData
    let authService: AuthenticateFirebaseProtocol = AuthenticateFirebase()
    func firebaseSignin(userData: userRegisterData, completion: @escaping (Result<Any>) -> Void)
    {
        authService.signin(userEmail: userData.userEmail, userPassword:  userData.userPassowrd) { (result) in
            switch result
            {
            case .success(let id):
                self.authData.sign(email: userData.userEmail, id: String(describing: id))
                completion(.success(""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func firebaseSignup(userData: userRegisterData, completion: @escaping (Result<Any>) -> Void)
    {
        authService.signup(userEmail: userData.userEmail, userPassword: userData.userPassowrd){ (result) in
            switch result
            {
            case .success(let id):
                self.authData.sign(email: userData.userEmail, id: String(describing: id))
                completion(.success(""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
