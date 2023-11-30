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
    case ingredients = "Ingredients"
} //for the picker to make a choice



struct SearchView: View {
    
    
    @State private var showAlternatives = true //Show category or area labels
    @State var inputSearchTerm: String = ""
    @State private var fetchedMeals: [MealDetails] = []
    @State private var selectedName: Selection = .category
    
    @StateObject var viewModel = MealViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ingredients.strIngredient, ascending: true)],
        animation: .default)
    private var ingredients: FetchedResults<Ingredients>
    
    
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
            ZStack(alignment: .top){
                LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                VStack {
                    
                    VStack{
                        
                        HStack{
                            TextField("Search", text: $inputSearchTerm)
                                .autocorrectionDisabled()
                                .onChange(of: inputSearchTerm) { newValue in
                                                    updateMeals()
                                                }
                            
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .resizable()
                                    .frame(width: 30,height: 30)
                                    
                            
                        }.foregroundColor(Theme.ColoredText)
                        
                        .padding()
                        .border(Theme.ColoredText)
                        .cornerRadius(10)
                        .padding([.top,.bottom],0)
                        .padding([.trailing,.leading])
                        VStack{
                            
                            
                            Picker("Select an item", selection: $selectedName) {
                                ForEach(Selection.allCases, id: \.self) { name in
                                    Text(name.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding([.leading,.trailing],5)
                            
                            VStack(alignment: .trailing){
                                if selectedName == .ingredients{
                                }else if selectedName == .category{
                                    HStack{
                                        //Button for Category show or not
                                        Button {
                                            
                                            self.showAlternatives.toggle()
                                        } label: {
                                            
                                            Image(systemName: showAlternatives ? "chevron.up.circle" : "chevron.down.circle")
                                                .resizable()
                                                    .frame(width: 20,height: 20)
                                                    .padding(.top, 15)
                                                    .foregroundColor(Theme.ColoredText)
                                        }
                                        .buttonStyle(FlatLinkStyle())
                                        .padding(.leading, 60)
                                        .frame(height: 0)
                                        Spacer()
                                    }
                                    //Button for Area show or not
                                } else if selectedName == .area {
                                    HStack{
                                        Button {
                                            self.showAlternatives.toggle()
                                        } label: {
                                            Image(systemName: showAlternatives ? "chevron.up.circle" : "chevron.down.circle")
                                                .resizable()
                                                .frame(width: 20,height: 20)
                                                    .padding(.top, 15)
                                                    
                                                    .foregroundColor(Theme.ColoredText)
                                            
                                        }
                                        .buttonStyle(FlatLinkStyle())
                                        .padding(0)
                                        .frame(height: 0)
                                    }
                                }
                            }.padding(.bottom, 5)
                            //Show what section that we are on. Is it category Area Ingredients?
                            if showAlternatives {
                                testContentView(
                                    selectedName: selectedName,
                                    categories: categories,
                                    areas: areas,
                                    ingredients: ingredients
                                    
                                    
                                )
                            } else if !showAlternatives && selectedName == .ingredients{
                                testContentView(
                                    selectedName: selectedName,
                                    categories: categories,
                                    areas: areas,
                                    ingredients: ingredients
                                    
                                )
                            }
                            
                        }
                        
                        
                    }.padding([.top,.bottom], 10)
                    //If ingredients then we dont show the Button to hide the category or area section
                    if selectedName == .ingredients{} else {
                        ScrollableMealView(meals: inputSearchTerm.isEmpty ? [] : fetchedMeals, saveMealAction: viewModel.saveMeal, viewModel: viewModel)
                    }
                    
                }
            }
        }
    }
    
    func updateMeals() {
        let searchTerm = inputSearchTerm.lowercased()
        if let cachedMeals = MealCache.shared.getMeals(forCategory: searchTerm) {
            self.fetchedMeals = cachedMeals
        } else {
            fetchAndUpdateMeals()
        }
    }
    private func fetchAndUpdateMeals() {
        let searchTerm = inputSearchTerm
        Task {
            do {
                let meals = try await APIClient().fetchAPI(for: searchTerm)
                DispatchQueue.main.async {
                    self.fetchedMeals = meals
                    MealCache.shared.saveMeals(meals, forCategory: searchTerm)
                }
            } catch {
                print("Error fetching meals: \(error)")
            }
        }
    }
    
}


struct testContentView: View {
    let selectedName: Selection
    let categories: FetchedResults<Category>
    let areas: FetchedResults<Area>
    let ingredients: FetchedResults<Ingredients>
    
    
    
    var body: some View {
        switch selectedName {
        case .category:
            ScrollableCategoryView(categories: categories)
        case .area:
            ScrollableAreaView(area: areas)
        case .ingredients:
            ScrollableIngredientsView(ingredients: ingredients)
        }
        
        
        
    }
    
}


struct SaveConfirmationView: View {
    var body: some View {
        Text("Meal Saved Successfully!")
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            .shadow(radius: 5)
    }
}
