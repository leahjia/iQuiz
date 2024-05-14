//
//  ContentView.swift
//  iQuiz
//
//  Created by Leah on 5/8/24.
//

import SwiftUI

struct Quiz: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var icon: String
}

struct ContentView: View {
    let quizzes = [
        Quiz(title: "Mathematics", description: "Math equations and theories", icon: "function"),
        Quiz(title: "Marvel Super Heroes", description: "Are you a true fan?", icon: "star.fill"),
        Quiz(title: "Science", description: "Explore the world of science", icon: "atom")
    ]
    
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            List(quizzes) { quiz in
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
            }
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

#Preview {
    ContentView()
}
