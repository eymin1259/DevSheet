//
//  QuestionRepositoryImpl.swift
//  DevSheet
//
//  Created by yongmin lee on 5/29/22.
//

import Foundation
import RxSwift
import Firebase
import SQLite3

final class QuestionRepositoryImpl: QuestionRepository {
    
    // MARK: properties
    var firebaseService: FirebaseService
    var sqliteService: SQLiteService
    
    // MARK: initialize
    init(
        firebaseService: FirebaseService,
        sqliteService: SQLiteService
    ) {
        self.firebaseService = firebaseService
        self.sqliteService = sqliteService
    }
    
    // MARK: methods
    func fetchQuestions(categoryGroup:MainTab, categoryId: String) -> Single<[Question]> {
        if categoryGroup == .favorite {
            return fetchAllFavoriteQuestions(categoryId: categoryId)
        } else {
            return firebaseService
                .get(
                    QuestionAPI.getQuestions(categoryId: categoryId)
                )
                .map { snapshot in
                    var ret = [Question]()
                    for doc in snapshot.documents {
                        let id = doc.documentID
                        let data = doc.data()
                        let question = QuestionDTO(id: id, dictionary: data).toDomain()
                        ret.append(question)
                    }
                    return ret
                }
        }
    }
    
    func addNewQuestion(categoryId: String, title: String) -> Single<String> {
        return firebaseService
            .post(
                QuestionAPI.addNewQuestion(categoryId: categoryId, title: title)
            )
            .map { $0.documentID }
    }
    
    func updateQuestion(questionId: String, field: [String:Any]) -> Single<Bool> {
        return firebaseService
            .post(
                QuestionAPI.updateQuestion(questionId: questionId, field: field)
            )
            .map { _ in
                return true
            }
    }
    
    func fetchAllFavoriteQuestions(categoryId: String?) -> Single<[Question]> {
        return Single<[Question]>.create { [unowned self] single in
            var result = [Question]()
            sqliteService.read(query: QuestionQuery.selectAllFavoriteQuestions(categoryId: categoryId)) { row in
                let id = String(cString: sqlite3_column_text(row, 0))
                let title = String(cString: sqlite3_column_text(row, 1))
                let categoryId = String(cString: sqlite3_column_text(row, 2))
                let timeStamp = String(cString: sqlite3_column_text(row, 3))
                let deletedInt = Int(sqlite3_column_int(row, 4))
                let dto = QuestionDTO(id: id, dictionary: [
                    "id": id,
                    "title": title,
                    "categoryId": categoryId,
                    "timeStamp": timeStamp,
                    "deleted": deletedInt == 0 ? false : true
                ])
                result.append(dto.toDomain())
            } errorHandler: { err in
                single(.failure(err))
            }
            single(.success(result))
            return Disposables.create()
        }
    }
    
    func saveFavoriteQuestion(question: Question) -> Single<Bool> {
        let questionDTO = QuestionDTO(
            id: question.id,
            dictionary: [
                "title": question.title,
                "categoryId": question.categoryId,
                "timeStamp": question.createdAt,
                "deleted": question.deleted
            ])
        return sqliteService.create(query: QuestionQuery.insertQuestion(questionDTO))
    }
    
}
