//
//  QuestionQuery.swift
//  DevSheet
//
//  Created by yongmin lee on 6/6/22.
//

import Foundation

enum QuestionQuery {
    case createQuestionTable
    case selectAllFavoriteQuestions(categoryId: String?)
    case insertQuestion(QuestionDTO)
    case deleteQuestion(questionId: String)
}

extension QuestionQuery: SQLiteQuery {
    
    func getQuery() -> String {
        switch self {
        case .createQuestionTable:
            return "CREATE TABLE IF NOT EXISTS Questions (id TEXT PRIMARY KEY, title TEXT, categoryId TEXT, timeStamp TEXT, deleted INTEGER);"
            
        case .selectAllFavoriteQuestions(let categoryId):
            if let categoryId = categoryId {
                return "SELECT * FROM Questions WHERE categoryId = '\(categoryId)' AND deleted = '0';"
            } else {
                return "SELECT * FROM Questions WHERE deleted = '0';"
            }
            
        case .insertQuestion(let questionDTO):
            let deletedInt = questionDTO.deleted ? 1 : 0
            return "INSERT INTO Questions (id, title, categoryId, timeStamp, deleted) VALUES ('\(questionDTO.id)', '\(questionDTO.title)', '\(questionDTO.categoryId)', '\(questionDTO.timeStamp)', '\(deletedInt)');"
            
        case .deleteQuestion(let questionId):
            return "DELETE FROM Questions WHERE id = '\(questionId)';"
        }
    }
}
