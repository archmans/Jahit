//
//  TransactionView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 09/06/25.
//

import SwiftUI

struct TransactionView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @StateObject private var tabBarVM = TabBarViewModel.shared
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(TransactionTab.allCases) { tab in
                        Button(action: {
                            withAnimation { viewModel.selectedTab = tab }
                        }) {
                            VStack(spacing: 8) {
                                Text(tab.rawValue)
                                    .font(.custom("PlusJakartaSans-Regular", size: 16))
                                    .foregroundColor(viewModel.selectedTab == tab ? .blue : .gray)
                                
                                Rectangle()
                                    .fill(viewModel.selectedTab == tab ? Color.blue : Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .background(Color.white)
                .padding(.bottom, 8)
                .padding(.top, 32)

                TabView(selection: $viewModel.selectedTab) {
                    OngoingTransactionsView(viewModel: viewModel)
                        .tag(TransactionTab.ongoing)
                    
                    CompletedTransactionsView(viewModel: viewModel)
                        .tag(TransactionTab.completed)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .padding(.bottom, 65)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.refreshTransactions()
                tabBarVM.show()
            }
        }
    }
}

struct OngoingTransactionsView: View {
    let viewModel: TransactionViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.getOngoingTransactionsSortedByRecent()) { transaction in
                    OngoingTransactionRow(transaction: transaction, viewModel: viewModel)
                }
            }
        }
    }
}

struct CompletedTransactionsView: View {
    let viewModel: TransactionViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.getCompletedTransactionsSortedByRecent()) { transaction in
                    CompletedTransactionRow(transaction: transaction, viewModel: viewModel)
                }
            }
        }
    }
}

struct OngoingTransactionRow: View {
    let transaction: Transaction
    let viewModel: TransactionViewModel

    var body: some View {
        NavigationLink(destination: 
            OrderDetailView(order: transaction.toOrder())
                .onAppear {
                    TabBarViewModel.shared.hide()
                }
        ) {
            HStack(spacing: 16) {
                Image("penjahit")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 120, height: 99)
                    .clipped()
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.tailorName)
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(transaction.itemsSummary)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    Text(transaction.totalPrice.idrFormatted)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text(transaction.status.rawValue)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }

                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())

        Divider()
            .background(Color.gray.opacity(0.3))
    }
}

struct CompletedTransactionRow: View {
    let transaction: Transaction
    let viewModel: TransactionViewModel
    @EnvironmentObject var userManager: UserManager
    @State private var showingRatingPopup = false

    var body: some View {
        NavigationLink(destination: 
            OrderDetailView(order: transaction.toOrder())
                .onAppear {
                    TabBarViewModel.shared.hide()
                }
        ) {
            HStack(spacing: 16) {
                Image("penjahit")
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 120, height: 99)
                    .clipped()
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(transaction.tailorName)
                        .font(.headline)
                        .foregroundColor(.black)
                    Text(transaction.itemsSummary)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }

                Spacer()

                if let currentTransaction = userManager.currentUser.transactions.first(where: { $0.id == transaction.id }),
                   !currentTransaction.hasReview {
                    Button("Nilai") {
                        showingRatingPopup = true
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 84, height: 36)
                    .background(Color.blue)
                    .cornerRadius(18)
                } else {
                    Text("Dinilai")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(width: 84, height: 36)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(18)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingRatingPopup) {
            RatingPopupView(
                isPresented: $showingRatingPopup,
                transaction: transaction
            ) { review in
                userManager.addReviewToTransaction(review: review)
            }
            .presentationBackground(Color.white)
        }

        Divider()
            .background(Color.gray.opacity(0.3))
    }
}


#Preview {
    TransactionView()
}
