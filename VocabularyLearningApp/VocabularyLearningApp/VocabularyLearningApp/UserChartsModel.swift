//
//  UserChartsModel.swift
//  VocabularyLearningApp
//
//  Created by Yusuf Özgül on 9.05.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation
import VocabularyLearningAppAPI

protocol UserChartsModelProtocol
{
    func fetchChart(timeInterval: String, timeValue: Int)
}

/*
 Kullanıcının öğrendiği kelimelere göre grafik verileri modeli.
 */

class UserChartModel: UserChartsModelProtocol
{
    let userChart: FetchUserChartsProtocol = FetchUserCharts()
    let messageService: MessageViewerProtocol = MessageViewer.messageViewer
    let authdata = UserData.userData
    weak var delegate: ChartResponseDelegate?
    
    func fetchChart(timeInterval: String, timeValue: Int)
    {
        authdata.reloadData()
        if authdata.isSign
        {
            userChart.learnCharts(userID: authdata.userID, timeInterval: timeInterval, timeValue: timeValue) { (result) in
                switch result {
                case .success(let value):
                    self.delegate?.loadedChart(date: value.date, values: value.correctArray)
                case .failure(let message):
                    self.messageService.failMessage(title: NSLocalizedString("A_ISSUE", comment: ""), body: "\(NSLocalizedString("ERROR_FETCH_CHART", comment: "")): \(message)")
                    self.delegate?.loadedChart(date: [], values: [])
                }
            }
        }
        else
        {
            messageService.failMessage(title: NSLocalizedString("NOT_SIGNIN", comment: ""), body: NSLocalizedString("PLEASE_SIGNIN_FOR_CHART", comment: ""))
        }
    }
}
