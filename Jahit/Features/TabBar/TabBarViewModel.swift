//
//  TabBarViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 07/05/25.
//

import SwiftUI

class TabBarViewModel: ObservableObject {
    static let shared = TabBarViewModel()
    
    @Published var selectedTab: Int = 0
    @Published var isVisible: Bool = true
    
    private init() {}
    
    func selectTab(_ index: Int) {
        selectedTab = index
        isVisible = true
    }
    
    func hide() {
        isVisible = false
    }
    
    func show() {
        isVisible = true
    }
}
