//
//  AuthenticateFirebase.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 24.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import FirebaseAuth
import Firebase

protocol AuthenticateFirebaseProtocol
{
    static func signin(userEmail: String, userPassword: String)
    static func signup(userEmail: String, userPassword: String)
}

public final class AuthenticateFirebase: AuthenticateFirebaseProtocol
{
    public static func signin(userEmail: String, userPassword: String)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (authResults, error) in
            if error != nil
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "fireBaseMessage"), object: (error?.localizedDescription)!)
            }
            else
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "fireBaseMessage"), object: "succes")
                var currentUser = currentUserData.init()
                currentUser.userEmail = authResults?.user.email
                currentUser.userID = authResults?.user.uid
                UserDefaults.standard.setValue([currentUser.userEmail, currentUser.userID], forKey: "currentUser")
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    public static func signup(userEmail: String, userPassword: String)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (authResult, error) in
            if error != nil
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "fireBaseMessage"), object: (error?.localizedDescription)!)
            }
            else
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "fireBaseMessage"), object: "succes")
                var currentUser = currentUserData.init()
                currentUser.userEmail = authResult?.user.email
                currentUser.userID = authResult?.user.uid
                UserDefaults.standard.setValue([currentUser.userEmail, currentUser.userID], forKey: "currentUser")
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}


