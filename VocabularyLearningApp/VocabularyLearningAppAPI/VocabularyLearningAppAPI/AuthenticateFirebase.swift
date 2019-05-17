//
//  AuthenticateFirebase.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 24.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import FirebaseAuth
import Firebase

public protocol AuthenticateFirebaseProtocol
{
    func signin(userEmail: String, userPassword: String, completion: @escaping (Result<String>) -> Void)
    func signup(userEmail: String, userPassword: String, completion: @escaping (Result<String>) -> Void)
}

public final class AuthenticateFirebase: AuthenticateFirebaseProtocol
{
    public init() {}
    
    public func signin(userEmail: String, userPassword: String, completion: @escaping (Result<String>) -> Void) // Gelen verilere göre giriş yapılır.
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (authResults, error) in
            if error != nil
            {
                completion(.failure(error!.localizedDescription))
            }
            else
            {
                completion(.success((authResults?.user.uid)!))
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    public func signup(userEmail: String, userPassword: String, completion: @escaping (Result<String>) -> Void) // Gelen verilere göre yeni kullanıcı oluşturulur.
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (authResult, error) in
            if error != nil
            {
                completion(.failure(error!.localizedDescription))
            }
            else
            {
                completion(.success((authResult?.user.uid)!))
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
}


