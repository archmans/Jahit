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
        NavigationView {
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
                                ForEach(viewModel.filteredTransactions) { transaction in
                                    if tab == .ongoing {
                                        OngoingTransactionRow(transaction: transaction, viewModel: viewModel)
                                    } else {
                                        CompletedTransactionRow(transaction: transaction, viewModel: viewModel)
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
            .onAppear {
                viewModel.refreshTransactions()
            }
        }
    }
}

struct OngoingTransactionRow: View {
    let transaction: Transaction
    let viewModel: TransactionViewModel

    var body: some View {
        NavigationLink(destination: OrderDetailView(order: transaction.toOrder())) {
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
        }
        .buttonStyle(PlainButtonStyle())

        Divider()
    }
}

struct CompletedTransactionRow: View {
    let transaction: Transaction
    let viewModel: TransactionViewModel

    var body: some View {
        NavigationLink(destination: OrderDetailView(order: transaction.toOrder())) {
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
                    
                    Text(transaction.formattedOrderDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                Button("Nilai") {
                    // TODO: Implement rating functionality
                    print("Rating transaction: \(transaction.id)")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 84, height: 36)
                .background(Color.blue)
                .cornerRadius(18)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())

        Divider()
    }
}


#Preview {
    TransactionView()
}
