//
//  TransactionView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 09/06/25.
//

import SwiftUI

struct TransactionView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @Namespace private var underlineNamespace
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(TransactionTab.allCases) { tab in
                    Button(action: {
                        withAnimation { viewModel.selectedTab = tab }
                    }) {
                        VStack(spacing: 4) {
                            Text(tab.rawValue)
                                .font(.system(size: 16,
                                              weight: viewModel.selectedTab == tab ? .semibold : .regular))
                                .foregroundColor(viewModel.selectedTab == tab ? .blue : .gray)

                            if viewModel.selectedTab == tab {
                                Rectangle()
                                    .fill(Color.blue)
                                    .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                                    .frame(height: 2)
                            } else {
                                Color.clear.frame(height: 2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            .padding(.top, 32)

            TabView(selection: $viewModel.selectedTab) {
                ForEach(TransactionTab.allCases) { tab in
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.filteredTasks) { task in
                                if tab == .ongoing {
                                    OngoingTransactionRow(task: task)
                                } else {
                                    CompletedTransactionRow(task: task) {
                                        viewModel.toggleCompletion(of: task)
                                    }
                                }
                            }
                        }
                    }
                    .tag(tab)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .padding(.bottom, 65)
        .background(Color(white: 0.95).edgesIgnoringSafeArea(.all))
    }
}

struct OngoingTransactionRow: View {
    let task: Transaction

    var body: some View {
        HStack(spacing: 16) {
            Image(task.imageName)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 120, height: 99)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(.headline)
                Text(task.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(task.price.idrFormatted)
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            Spacer()
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)

        Divider()
    }
}

struct CompletedTransactionRow: View {
    let task: Transaction
    let onRate: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image(task.imageName)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(width: 120, height: 99)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(.headline)
                Text(task.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button("Nilai", action: onRate)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 84, height: 36)
                .background(Color.blue)
                .cornerRadius(18)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)

        Divider()
    }
}


#Preview {
    TransactionView()
}
