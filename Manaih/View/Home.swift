//
//  Home.swift
//  Manaih
//
//  Created by Soyombo Mantaagiin on 17.02.2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Home: View {
    @State private var quizInfo: Info?
    @State private var questions: [Question] = []
    @AppStorage("log_status") private var logStatus: Bool = false
    
    var body: some View {
        if let info = quizInfo {
            VStack(spacing: 10) {
                Text(info.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .hAllign(.leading)
                
                CustomLabel("list.bullet.rectangle.portrait", "\(questions.count)", "Multiple Choice Questions")
                    .padding(.top, 20)
                
                CustomLabel("person", "\(info.peopleAttended)", "Attended the exercise")
                    .padding(.top, 5)
                
                Divider()
                    .padding(.horizontal, -15)
                    .padding(.top,15)
            }
            .padding(15)
            
            
        } else {
            VStack {
                ProgressView()
                Text("Please wait")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .task {
                do {
                   try await fetchData()
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    @ViewBuilder
    func CustomLabel(_ image: String, _ title: String, _ subTitle: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: image)
                .font(.title3)
                .frame(width: 45, height: 45)
                .background {
                    Circle()
                        .fill(.gray.opacity(0.1))
                        .padding(-1)
                        .background {
                            Circle()
                                .stroke(Color("BG"), lineWidth: 1)
                        }
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("BG"))
                Text(subTitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            .hAllign(.leading)
        }
        
    }
    
    /// - Fetching
    func fetchData() async throws {
        try await loginUserAnonymous()
        let info = try await Firestore.firestore().collection("Quiz").document("Info").getDocument().data(as: Info.self)
        let questions = try await Firestore.firestore().collection("Quiz").document("Info").collection("Questions").getDocuments().documents.compactMap {
            try $0.data(as: Question.self)
        }
        
        await MainActor.run(body: {
            self.quizInfo = info
            self.questions = questions
        })
    }
    
    // login user
    func loginUserAnonymous() async throws{
        if !logStatus {
            try await Auth.auth().signInAnonymously()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


extension View {
    func hAllign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAllign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}
