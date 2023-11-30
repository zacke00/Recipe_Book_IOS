//
//  ScrollableAreaView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 16/11/2023.
//

import SwiftUI

struct ScrollableAreaView: View {
    var area: FetchedResults<Area>
    
    
    
    var body: some View {
        VStack{
            Text("Area")
            
                .bold()
                .font(.title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(area, id: \.self) { area in
                        
                        AreaItemView(area: area, saveMealAction: MealViewModel().saveMeal)
                    }
                }
                .padding([.bottom, .top], 10)
            }
        }.padding(0)
    }
}

struct AreaItemView: View {
    var area: Area
    var saveMealAction: (MealDetails) -> Void
    
    
    let areaToCountryCode: [String: String] = [
        "American": "US",
        "British": "GB",
        "Canadian": "CA",
        "Chinese": "CN",
        "Croatian": "HR",
        "Dutch": "NL",
        "Egyptian": "EG",
        "Filipino": "PH",
        "French": "FR",
        "Greek": "GR",
        "Indian": "IN",
        "Irish": "IE",
        "Italian": "IT",
        "Jamaican": "JM",
        "Japanese": "JP",
        "Kenyan": "KE",
        "Malaysian": "MY",
        "Mexican": "MX",
        "Moroccan": "MA",
        "Polish": "PL",
        "Portuguese": "PT",
        "Russian": "RU",
        "Spanish": "ES",
        "Thai": "TH",
        "Tunisian": "TN",
        "Turkish": "TR",
        "Unknown": "", 
        "Vietnamese": "VN"
    ]
    var body: some View {
        NavigationLink(destination: MealsByArea(area: area)) {
            ZStack {
                Theme.third
                    .cornerRadius(10)
                    .shadow(color: Theme.shadowColor, radius: 5, x: 0, y: 3)
                
                VStack {
                    
                    if let areaName = area.strArea, let countryCode = areaToCountryCode[areaName] {
                        AsyncImage(url: URL(string: "https://flagsapi.com/\(countryCode)/shiny/64.png")) { image in
                            image.resizable()
                        } placeholder: {
                            
                            Image(systemName: "questionmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                        .frame(width: 50, height: 40)
                    }
                    Text(area.strArea ?? "unknown")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(Theme.text)
                }
                .padding([.top, .bottom], 5)
            }
            .frame(width: 110, height: 100)
            .padding([.leading], 5)
        }
        
    }
}

struct MealsByArea: View {
    var area: Area
    @State private var mealIDs: [String] = []
    @State private var isLoading: Bool = false
    @StateObject private var viewModel = MealViewModel()
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        ForEach(mealIDs, id: \.self) { mealID in
                            MealByIdView(mealID: mealID, category: "", area: area.strArea!,
                                          viewModel: viewModel)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle(area.strArea ?? "Area")
            .onAppear {
                fetchMealsByArea()
            }
            
            // Save confirmation popup
            
        }
    }

           // Function to save a meal and show the confirmation

    private func fetchMealsByArea() {
        isLoading = true
        let areaName = area.strArea ?? ""
        
        if let cachedMeals = MealCache.shared.getMeals(forArea: areaName) {
            mealIDs = cachedMeals.map { $0.idMeal }
            isLoading = false
        } else {
            Task {
                do {
                    let meals = try await APIClient().fetchMealsForArea(area: areaName)
                    DispatchQueue.main.async {
                        mealIDs = meals.map { $0.idMeal }
                        MealCache.shared.saveMeals(meals, forArea: areaName)
                        isLoading = false
                    }
                } catch {
                    print("Error fetching meals for Area: \(error)")
                    isLoading = false
                }
            }
        }
    }
}
