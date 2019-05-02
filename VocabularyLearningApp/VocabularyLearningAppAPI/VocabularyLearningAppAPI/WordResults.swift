//
//  WordResults.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 1.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

public enum Result<Value>
{
    case success(Value)
    case failure
}
