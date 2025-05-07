//
//  TabBarViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 07/05/25.
//

import SwiftUI

class TabBarViewModel: ObservableObject {
    static var shared: TabBarViewModel = TabBarViewModel()
    
    @Published var selectedTab: Int = 0
    
    func selectTab(_ index: Int) {
        selectedTab = index
    }
}
