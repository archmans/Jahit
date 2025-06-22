//
//  HomeViewModel.swift
//  Jahit
//
//  Created by Muhamad Salman Hakim Alfarisi on 18/05/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var model: HomeModel
    
    init(model: HomeModel = .example) {
        self.model = model
    }
    
    var filteredTailors: [Tailor] {
        return model.tailors
    }
}
