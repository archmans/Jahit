//
//  TransactionViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 09/06/25.
//

import SwiftUI

class TransactionViewModel: ObservableObject {
    @Published private(set) var tasks: [Transaction] = []

    @Published var selectedTab: TransactionTab = .ongoing

    init() {
        loadSampleData()
    }

    var filteredTasks: [Transaction] {
        switch selectedTab {
        case .ongoing:
            return tasks.filter { !$0.isCompleted }
        case .completed:
            return tasks.filter { $0.isCompleted }
        }
    }

    func toggleCompletion(of task: Transaction) {
        guard let idx = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[idx].isCompleted.toggle()
    }

    private func loadSampleData() {
        tasks = [
            Transaction(name: "Alfa Tailor", subtitle: "Batik", imageName: "penjahit", price: 180_000, isCompleted: false),
            Transaction(name: "Beta Tailor", subtitle: "Gamis, Mukena",    imageName: "penjahit", price: 220_000, isCompleted: false),
            Transaction(name: "Gamma Tailor", subtitle: "Jaket, Mantel",   imageName: "penjahit", price: 350_000, isCompleted: true),
            Transaction(name: "Delta Tailor", subtitle: "Kemeja, Celana",  imageName: "penjahit", price: 150_000, isCompleted: true),
            Transaction(name: "Alfa Tailor", subtitle: "Batik", imageName: "penjahit", price: 180_000, isCompleted: false),
            Transaction(name: "Beta Tailor", subtitle: "Gamis, Mukena",    imageName: "penjahit", price: 220_000, isCompleted: false),
            Transaction(name: "Gamma Tailor", subtitle: "Jaket, Mantel",   imageName: "penjahit", price: 350_000, isCompleted: true),
            Transaction(name: "Delta Tailor", subtitle: "Kemeja, Celana",  imageName: "penjahit", price: 150_000, isCompleted: true),
            Transaction(name: "Alfa Tailor", subtitle: "Batik", imageName: "penjahit", price: 180_000, isCompleted: false),
            Transaction(name: "Beta Tailor", subtitle: "Gamis, Mukena",    imageName: "penjahit", price: 220_000, isCompleted: false),
            Transaction(name: "Gamma Tailor", subtitle: "Jaket, Mantel",   imageName: "penjahit", price: 350_000, isCompleted: true),
            Transaction(name: "Delta Tailor", subtitle: "Kemeja, Celana",  imageName: "penjahit", price: 150_000, isCompleted: true)
        ]
    }
}
