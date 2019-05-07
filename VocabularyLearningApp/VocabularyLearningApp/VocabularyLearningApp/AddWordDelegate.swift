//
//  AddWordDelefate.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 7.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

public protocol AddWordDelegate: class // Butona tıklandığında veri taşımada görev alan interface.
{
    func addWordResult(result: Bool)
}

