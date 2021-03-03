//Created for churchApp  (28.10.2020 )

import Foundation


struct MealsListResponse: Decodable {
    let mealsList: [MealResponse]
}

struct MealResponse: Decodable {
    let id: Int
    let name: String
    let ingredients: [String]
      
}
