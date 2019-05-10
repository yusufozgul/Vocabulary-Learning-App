//
//  solvedWordsResponse.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 10.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

public struct solvedWordsResponse
{
    public var result: [String]
    
    init(result: [String])
    {
        self.result = result
    }
}
