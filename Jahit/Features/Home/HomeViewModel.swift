//
//  HomeViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 18/05/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var model: HomeModel
    
    init(model: HomeModel = .example) {
        self.model = model
    }
    
    var filteredTailors: [Tailor] {
        if searchText.isEmpty {
            return model.tailors
        } else {
            return model.tailors.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
