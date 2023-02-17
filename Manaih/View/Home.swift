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
            Text(info.title)
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
