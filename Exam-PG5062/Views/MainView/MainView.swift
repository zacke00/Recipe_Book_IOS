//
//  MainView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 27/11/2023.
//

import SwiftUI
struct MainView: View {
    @State private var showAnimation = true
    @State private var isLoading = false
    @State private var meal: MealDetails?
    @State private var showSaveConfirmation = false
    @Environment(\.scenePhase) private var scenePhase
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                
                
                if showAnimation {
                    StartupAnimationView() {
                        showAnimation = false
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("Welcome")
                            .bold()
                            .font(.title)
                            .foregroundColor(Theme.ColoredText)
                        Text("We have multiple different recipes and we are here to help you explore the world of cooking.")
                            .font(.title3)
                            .foregroundColor(Theme.ColoredText)
                        
                            Text("Let's begin!")
                                .font(.title3)
                                .foregroundColor(Theme.ColoredText)
                        
                        Spacer()
                        Text("Here are some random recipes for you to get started :)").foregroundColor(Theme.ColoredText)
                        
                        
                        
                        if let meal = meal {
                            NavigationLink(destination: displayFocusedMealView(meal: meal, saveMeal: MealViewModel().saveMeal, showSaveConfirmation: showSaveConfirmation, viewModel: MealViewModel())){
                                DisplayRandomMeal(meal: meal)
                            }
                        } else {
                            Text("No meal loaded").foregroundColor(Theme.ColoredText)
                        }
                        
                        Button {
                            fetchRandomMeal()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }.buttonStyle(FlatLinkStyle())
                        .padding()
                        Spacer()
                    }
                }
                
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                onAppLaunchOrResume() // Fetch when the app becomes active
            }
        }
    }
    
    private func onAppLaunchOrResume() {
        
        fetchRandomMeal()
}
    
    private func fetchRandomMeal() {
        isLoading = true
        
        
        Task {
            do {
                let fetchedMeals = try await APIClient().fetchRandomMeal()
                if let fetchedMeal = fetchedMeals.first {
                    self.meal = fetchedMeal
                    
                } else {
                    print("Meal Not Found")
                }
            } catch let error{
                print(error)
            }
        }
    }
}

struct DisplayRandomMeal: View{
    var meal: MealDetails
    
        var body: some View {
            VStack {
                ZStack(alignment: .top) {
                    Rectangle()
                        .cornerRadius(20)
                        .foregroundColor(Theme.primary)
                        .shadow(color: Theme.shadowColor, radius: 5, x: 5, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Theme.third, lineWidth: 2)
                        )
                    
                    VStack {
                        AsyncImageView(url: meal.strMealThumb)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 340, height: 200)
                        .clipShape(RoundedCorner(radius: 10, corner: .topLeft))
                        .clipShape(RoundedCorner(radius: 10, corner: .topRight))

                        VStack {
                            Text(meal.strMeal)
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                            
                            HStack {
                                Spacer()
                                VStack {
                                    Text(meal.strTags ?? "")
                                }
                                Spacer()
                                VStack {
                                    Text(meal.strArea ?? "")
                                    Text(meal.strCategory ?? "")
                                }
                                Spacer()
                            }
                        }
                        .foregroundColor(Theme.ColoredText)
                    }
                    .padding(.bottom, 10)
                }
            }
            .frame(width: 340)
            .frame(maxHeight: 340)
            .padding()
            .id(meal.idMeal) // Key the view on the meal ID
        }
    }
