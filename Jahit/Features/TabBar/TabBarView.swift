//
//  NavBarView.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 07/05/25.
//

import SwiftUI

struct TabBarView: View {
    @ObservedObject var tabBarVM = TabBarViewModel()
    
    var body: some View {
        ZStack {
            switch tabBarVM.selectedTab {
            case 0:
                HomeView()
            case 1:
                TransactionView()
            case 2:
                Text("Profil")
            default:
                HomeView()
            }
            
            VStack {
                Spacer()
                HStack {
                    TabButton(isSelected: tabBarVM.selectedTab == 0, title: "Home", icon: "home", filledIcon: "home.fill") {
                        withAnimation {
                            tabBarVM.selectedTab = 0
                        }
                    }
                    TabButton(isSelected: tabBarVM.selectedTab == 1, title: "Transaksi", icon: "transaction", filledIcon: "transaction.fill") {
                        withAnimation {
                            tabBarVM.selectedTab = 1
                        }
                    }
                    TabButton(isSelected: tabBarVM.selectedTab == 2, title: "Profil", icon: "profile", filledIcon: "profile.fill") {
                        withAnimation {
                            tabBarVM.selectedTab = 2
                        }
                    }
                    
                }
                .padding(.top, 16)
                .padding(.bottom, 8)
                .padding(.horizontal, 12)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: -2)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    TabBarView()
}
