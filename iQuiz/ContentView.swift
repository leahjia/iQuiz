//
//  ContentView.swift
//  iQuiz
//
//  Created by Leah on 5/8/24.
//

import SwiftUI

struct Quiz: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var description: String
    var icon: String
    var questions: [Question]
    
    static func ==(lhs: Quiz, rhs: Quiz) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Question: Identifiable, Hashable {
    var id = UUID()
    var text: String
    var answers: [Answer]
}

struct Answer: Identifiable, Equatable, Hashable {
    var id = UUID()
    var text: String
    var isCorrect: Bool
    
    static func ==(lhs: Answer, rhs: Answer) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ContentView: View {
    let quizzes = [
        Quiz(title: "Mathematics", description: "Math equations and theories", icon: "function",
             questions: [
                Question(text: "What is the square root of 16?", answers: [
                    Answer(text: "3", isCorrect: false),
                    Answer(text: "4", isCorrect: true),
                    Answer(text: "5", isCorrect: false)
                ]),
                Question(text: "What is 5 + 3?", answers: [
                    Answer(text: "7", isCorrect: false),
                    Answer(text: "8", isCorrect: true),
                    Answer(text: "9", isCorrect: false)
                ]),
                Question(text: "What is the derivative of x^2?", answers: [
                    Answer(text: "x", isCorrect: false),
                    Answer(text: "2x", isCorrect: true),
                    Answer(text: "x^2", isCorrect: false)
                ])
             ]),
        Quiz(title: "Marvel Super Heroes", description: "Are you a true fan?", icon: "star.fill",
             questions: [
                Question(text: "Who is Iron Man?", answers: [
                    Answer(text: "Steve Rogers", isCorrect: false),
                    Answer(text: "Tony Stark", isCorrect: true),
                    Answer(text: "Bruce Banner", isCorrect: false)
                ]),
                Question(text: "Who is the God of Thunder?", answers: [
                    Answer(text: "Loki", isCorrect: false),
                    Answer(text: "Thor", isCorrect: true),
                    Answer(text: "Odin", isCorrect: false)
                ]),
                Question(text: "What is Captain America's shield made of?", answers: [
                    Answer(text: "Adamantium", isCorrect: false),
                    Answer(text: "Vibranium", isCorrect: true),
                    Answer(text: "Carbonadium", isCorrect: false)
                ])
             ]),
        Quiz(title: "Science", description: "Explore the world of science", icon: "atom",
             questions: [
                Question(text: "What is the chemical symbol for oxygen?", answers: [
                    Answer(text: "O2", isCorrect: true),
                    Answer(text: "H2O", isCorrect: false),
                    Answer(text: "CO2", isCorrect: false)
                ]),
                Question(text: "What planet is known as the Red Planet?", answers: [
                    Answer(text: "Earth", isCorrect: false),
                    Answer(text: "Mars", isCorrect: true),
                    Answer(text: "Jupiter", isCorrect: false)
                ]),
                Question(text: "What is the speed of light?", answers: [
                    Answer(text: "300,000 km/s", isCorrect: true),
                    Answer(text: "150,000 km/s", isCorrect: false),
                    Answer(text: "450,000 km/s", isCorrect: false)
                ])
             ])
    ]
    
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            QuizListView(quizzes: quizzes)
                .navigationTitle("Select Topics")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            showSettings = true
                        }) {
                            Text("Settings")
                        }
                        .alert(isPresented: $showSettings) {
                            Alert(title: Text("Settings go here"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
        }
    }
}

struct QuizListView: View {
    let quizzes: [Quiz]
    
    var body: some View {
        List(quizzes) { quiz in
            NavigationLink(value: quiz) {
                HStack {
                    Image(systemName: quiz.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(quiz.title)
                            .font(.headline)
                        Text(quiz.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationDestination(for: Quiz.self) { quiz in
            QuestionView(quiz: quiz, currentQuestionIndex: 0, score: 0)
        }
    }
}

struct QuestionView: View {
    let quiz: Quiz
    @State var currentQuestionIndex: Int
    @State var selectedAnswer: Answer? = nil
    @State var score: Int
    @State private var navigateToAnswerView = false

    var body: some View {
        let question = quiz.questions[currentQuestionIndex]

        VStack {
            Text(question.text)
                .font(.title)
                .padding()

            List(question.answers) { answer in
                HStack {
                    Text(answer.text)
                    Spacer()
                    if selectedAnswer == answer {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedAnswer = answer
                }
            }

            NavigationLink(destination: AnswerView(
                quiz: quiz,
                question: question,
                selectedAnswer: selectedAnswer ?? question.answers[0],
                currentQuestionIndex: currentQuestionIndex,
                score: score
            )) {
                Text("Submit")
            }
            .padding()
            .disabled(selectedAnswer == nil)
        }
        .navigationTitle("Question \(currentQuestionIndex + 1)")
    }
}

struct AnswerView: View {
    let quiz: Quiz
    let question: Question
    let selectedAnswer: Answer
    let currentQuestionIndex: Int
    @State var score: Int
    @State private var navigateToNextQuestion = false
    @State private var navigateToFinishedView = false

    var body: some View {
        VStack {
            Text(question.text)
                .font(.title)
                .padding()

            ForEach(question.answers) { answer in
                HStack {
                    Text(answer.text)
                    Spacer()
                    if answer == selectedAnswer {
                        Image(systemName: selectedAnswer.isCorrect ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(selectedAnswer.isCorrect ? .green : .red)
                    } else if answer.isCorrect {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }

            Button(action: {
                if selectedAnswer.isCorrect {
                    score += 1
                }
                if currentQuestionIndex + 1 < quiz.questions.count {
                    navigateToNextQuestion = true
                } else {
                    navigateToFinishedView = true
                }
            }) {
                Text("Next")
            }
            .padding()
            .background(
                NavigationLink(
                    destination: QuestionView(
                        quiz: quiz,
                        currentQuestionIndex: currentQuestionIndex + 1,
                        score: score
                    ),
                    isActive: $navigateToNextQuestion
                ) {
                    EmptyView()
                }
            )
            .background(
                NavigationLink(
                    destination: FinishedView(
                        quiz: quiz,
                        score: score
                    ),
                    isActive: $navigateToFinishedView
                ) {
                    EmptyView()
                }
            )
        }
        .navigationTitle("Answer")
        .navigationBarBackButtonHidden(true)
    }
}

struct FinishedView: View {
    let quiz: Quiz
    let score: Int
    
    var body: some View {
        VStack {
            Text("Quiz Finished!")
                .font(.title)
                .padding()
            
            Text("You scored \(score) out of \(quiz.questions.count)")
                .font(.headline)
                .padding()
            
            NavigationLink(destination: ContentView()) {
                Text("Back to Topics")
            }
            .padding()
        }
        .navigationTitle("Results")
        .navigationBarBackButtonHidden(true)
    }
}

enum NavigationDestination: Hashable {
    case answer(quiz: Quiz, question: Question, selectedAnswer: Answer, currentQuestionIndex: Int, score: Int)
    case finished(quiz: Quiz, score: Int)
}

#Preview {
    ContentView()
}
