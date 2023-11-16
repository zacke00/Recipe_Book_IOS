//
//  Decodables.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 14/11/2023.
//

import Foundation

//API is built where we allways need to bypass the first Meals response from api and focus on the actual data
struct CategoryResponse: Codable {
    let categories: [CategoryDetails]
}

struct MealsResponse: Codable {
    let meals: [MealDetails]?
}

struct IngredientsResponse: Codable{
    let meals: [IngredientDetails]
}

struct AreaResponse: Codable{
    let meals: [AreaDetails]
}




struct CategoryDetails: Codable {
    let strCategory: String
    let strCategoryThumb: String
}
struct MealDetails: Codable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String
    let strCategory: String
    let strArea: String
    
    
}

struct IngredientDetails: Codable {
    let idIngredient: String
    let strIngredient: String
    let strDescription: String
    let strType: String
}

struct AreaDetails: Codable{
    let strArea: String?
    
}
