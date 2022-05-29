//
//  QuestionListSection.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxDataSources

struct QuestionListSection {
    var questionList: [Question]
}

extension QuestionListSection: SectionModelType {
    
    var items: [Question] {
        return self.questionList
    }
    
    init(original: QuestionListSection, items: [Question]) {
        self = original
        self.questionList = items
    }
}
