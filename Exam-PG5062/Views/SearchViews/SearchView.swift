//
//  FavoritesView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 14/11/2023.
//

import SwiftUI
import CoreData

enum Selection: String, CaseIterable {
    case category = "Category"
    case area = "Area"
    
}



struct SearchView: View {
    
    
    var areaDemo: [String]
    
    
    @State var inputSearchTerm: String = ""
    @State private var fetchedMeals: [MealDetails] = []
    @State private var selectedName: Selection = .category
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.strCategory, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<Category>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Area.strArea, ascending: true)],
        animation: .default)
    private var areas: FetchedResults<Area>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.strMeal, ascending: true)],
        animation: .default)
    private var meals: FetchedResults<Meal>
    

    var body: some View {
        
        NavigationView {
            ZStack{
                Theme.primary.ignoresSafeArea(.all)
                VStack {
                    
                    VStack{
                        
                        HStack{
                            TextField("Search", text: $inputSearchTerm)
                                .autocorrectionDisabled()
                            Button(action: updateMeals) {
                                Image(systemName: "magnifyingglass.circle.fill")
                                                                .resizable()
                                                                .frame(width: 30,height: 30)
                                                                .foregroundColor(Theme.third)
                            }
                            .foregroundColor(Theme.text)
                            
                        }
                        
                        .padding()
                        .border(Theme.secoundary)
                        .cornerRadius(10)
                        .padding([.top,.bottom],0)
                        .padding([.trailing,.leading])
                        
                        ScrollView {
                            VStack{
                                
                                
                                Picker("Select an item", selection: $selectedName) {
                                    ForEach(Selection.allCases, id: \.self) { name in
                                        Text(name.rawValue)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding([.leading,.trailing],5)
                            }
                            
                            
                            testContentView(
                                selectedName: selectedName,
                                categories: categories,
                                areas: areas,
                                fetchedMeals: fetchedMeals, // Pass fetchedMeals here
                                saveMealAction: saveMeal,
                                inputSearchTerm: inputSearchTerm
                            )
                            
                        }
                        
                        
                        
                    }.padding([.top,.bottom], 10)
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        deleteItems()
                    } label: {
                        Label("Delete Data", systemImage: "trash")
                    }.foregroundColor(Theme.text)
                    
                }
                
            }.padding(0)
        }
    }
    
    
    func deleteItems() {
        withAnimation {
            for meal in meals {
                viewContext.delete(meal)
            }
            do {
                try viewContext.save()
            } catch {
                print("Error deleting items: \(error)")
            }
        }
    }
    
    func generateAlphabetLetters() -> [String] {
        let letters = (0..<26).map { i in
            return "\(Character(UnicodeScalar("a".unicodeScalars.first!.value + UInt32(i))!))"
        }
        return letters
    }
    
    
    
    func saveMeal(mealDetails: MealDetails) {
        let context = PersistenceController.shared.container.viewContext
        context.perform {
            // Check if the meal already exists in the database
            let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "idMeal == %@", mealDetails.idMeal )
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.isEmpty {
                    // Save the meal if it doesn't exist
                    let newMeal = Meal(context: context)
                    newMeal.idMeal = mealDetails.idMeal
                    newMeal.strMeal = mealDetails.strMeal
                    newMeal.strTags = mealDetails.strTags
                    newMeal.strInstructions = mealDetails.strInstructions
                    newMeal.strMealThumb = mealDetails.strMealThumb
                    newMeal.strYoutube = mealDetails.strYoutube

                    // Set the Category and Area
                    newMeal.category = try fetchOrCreateCategory(withName: mealDetails.strCategory, in: context)
                    newMeal.area = try fetchOrCreateArea(withName: mealDetails.strArea, in: context)

                    try context.save()
                }
            } catch {
                print("Failed to save meal: \(error)")
            }
        }
    }
    
    func updateMeals() {
        Task {
                fetchedMeals = await APIClient().fetchAPI(for: inputSearchTerm)
            }
    }

    func fetchOrCreateCategory(withName categoryName: String, in context: NSManagedObjectContext) throws -> Category {
        let categoryFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoryFetchRequest.predicate = NSPredicate(format: "strCategory == %@", categoryName)
        
        let categories = try context.fetch(categoryFetchRequest)
        if let category = categories.first {
            return category
        } else {
            let newCategory = Category(context: context)
            newCategory.strCategory = categoryName
            return newCategory
        }
    }

    func fetchOrCreateArea(withName areaName: String, in context: NSManagedObjectContext) throws -> Area {
        let areaFetchRequest: NSFetchRequest<Area> = Area.fetchRequest()
        areaFetchRequest.predicate = NSPredicate(format: "strArea == %@", areaName)
        
        let areas = try context.fetch(areaFetchRequest)
        if let area = areas.first {
            return area
        } else {
            let newArea = Area(context: context)
            newArea.strArea = areaName
            return newArea
        }
    }
}



struct testContentView: View {
    let selectedName: Selection
    let categories: FetchedResults<Category>
    let areas: FetchedResults<Area>
    let fetchedMeals: [MealDetails]
    let saveMealAction: (MealDetails) -> Void
    let inputSearchTerm: String
    
    var body: some View {
        switch selectedName {
        case .category:
            ScrollableCategoryView(categories: categories)
        case .area:
            ScrollableAreaView(area: areas)
        }
        ScrollableMealView(meals: inputSearchTerm.isEmpty ? [] : fetchedMeals, saveMealAction: saveMealAction)
    }
}



