//
//  QuizQuestions.swift
//  InfoEducatie
//
//  Created by Calin Gavriliu on 14.07.2024.
//

import Foundation

struct QuizQuestion: Identifiable {
    var id = UUID()
    var question: String
}

let quizQuestions: [QuizQuestion] = [
    QuizQuestion(question: "Cum ai evalua nivelul tău de energie astăzi?"),
    QuizQuestion(question: "Cât de des te-ai simțit azi anxios sau stresat?"),
    QuizQuestion(question: "Cum ai dormit noaptea trecută?"),
    QuizQuestion(question: "Cât de mult te-au deranjat zgomotele puternice sau luminile intense azi?"),
    QuizQuestion(question: "Cât de des ai simțit nevoia de a te retrage într-un loc liniștit azi?"),
    QuizQuestion(question: "Cât de frecvent te-ai simțit azi deconectat sau absent din punct de vedere emoțional?")
]
