import Foundation

struct HomeModel {
    let tailors: [Tailor]
    let categories: [String]
    
    static let example = HomeModel(
        tailors: Tailor.sampleTailors,
        categories: ["atasan", "bawahan", "terusan"]
    )
}
