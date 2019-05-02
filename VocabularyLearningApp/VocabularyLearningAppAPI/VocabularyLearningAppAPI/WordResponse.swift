//
//  WordResponse.swift
//  VocabularyLearningAppAPI
//
//  Created by Yusuf Özgül on 1.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

public struct FetchWordResponse
{
    public var results: [WordData]
    
    init(results: [WordData])
    {
        self.results = results
    }
}
public struct FetchTestWordReponse
{
    public var results: [TestedWordData]
    
    init(results: [TestedWordData])
    {
        self.results = results
    }
}
