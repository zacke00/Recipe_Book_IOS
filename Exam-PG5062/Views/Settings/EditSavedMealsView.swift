//
//  EditSavedMealsView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 29/11/2023.
//

import SwiftUI

struct EditSavedMealsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.strMeal, ascending: true)],
        animation: .default)
    private var meals: FetchedResults<Meal>

    var body: some View {
        ZStack{
            LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            List {
                ForEach(meals) { meal in
                    NavigationLink(destination: MealEditView(meal: meal)) {
                        Text(meal.strMeal ?? "Unknown Meal")
                    }
                }
            }
            .background(LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all))
                .scrollContentBackground(.hidden)
            .navigationTitle("Edit Meals")
        }
    }
}



struct MealEditView: View {
    @ObservedObject var meal: Meal
    @State private var isPressed = false
    @State private var showAlert = false
    @State private var showPopup = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        ZStack(alignment: .top){
                LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                ScrollView{
                    VStack{
                    
                    VStack{
                        Text("Meal Name").bold()
                            .foregroundColor(Theme.ColoredText)
                            .padding(.bottom, 5)
                        Rectangle().frame(height: 1)
                            .foregroundColor(.gray)
                        
                        TextField("Meal Name", text: Binding(
                            get: { meal.strMeal ?? "" },
                            set: { meal.strMeal = $0 }
                        ))
                        
                        Text("Meal Instructions").bold()
                            .foregroundColor(Theme.ColoredText)
                            .padding(.bottom, 5)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                        
                        
                        TextField("Meal Instructions", text: Binding(
                            get: { meal.strInstructions ?? ""},
                            set: { meal.strInstructions = $0 }
                        ))
                        
                        
                        Text("Meal Thumbnail")
                            .bold()
                            .foregroundColor(Theme.ColoredText)
                            .padding(.bottom, 5)
                        Rectangle().frame(height: 1)
                            .foregroundColor(.gray)
                        
                        Text("This needs to be a URL:")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        
                        TextField("Meal Thumbnail", text: Binding(
                            get: { meal.strMealThumb ?? ""},
                            set: { meal.strMealThumb = $0 }
                        ))
                        
                    }
                    VStack{
                        AsyncImageView(url: meal.strMealThumb ?? "")
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipped()
                            .cornerRadius(10)
                        
                        
                        Text("Meal Measurements").bold()
                            .foregroundColor(Theme.ColoredText)
                            .padding(.bottom, 5)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                        
                        ForEach(meal.measurements?.allObjects as? [Measurements] ?? [], id: \.self) { measurement in
                            if let ingredient = measurement.strIngredients, let measure = measurement.strMeasure {
                                MeasurementEditView(measurement: measurement)
                                
                            }
                        }
                        
                    }
                    Spacer()
                    VStack{
                        
                        
                        
                        Button {
                            UpdateMeal()
                            print("HELLO")
                        } label: {
                            Text("save")
                        }
                        .frame(minWidth: 0, maxWidth: 300)
                        .padding()
                        .background(Theme.ButtonColor)
                        .foregroundColor(Theme.text)
                        .cornerRadius(10)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .animation(.spring(), value: isPressed)
                        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                            self.isPressed = pressing
                        }, perform: {})
                        
                    }
                    }.padding([.trailing, .leading], 5)
                
            }
                VStack{
                    if showPopup {
                        SaveConfirmationView()
                            .transition(.move(edge: .top))
                            .animation(.easeInOut, value: showPopup)
                            .zIndex(1)
                            .padding(.top, 20)
                    }

                }
        }
        
    }
    private func UpdateMeal() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                showPopup = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showPopup = false
                }
            } catch {
                print("Error saving meal: \(error.localizedDescription)")
                
            }
        } else {
            print("No changes to save")
        }
    }
}


struct MeasurementEditView: View {
    @ObservedObject var measurement: Measurements

    var body: some View {
        TextField("Ingredient", text: Binding(
            get: { measurement.strIngredients ?? "" },
            set: { measurement.strIngredients = $0 }
        ))
        .padding(.bottom, 5)
        TextField("Measure", text: Binding(
            get: { measurement.strMeasure ?? "" },
            set: { measurement.strMeasure = $0 }
        ))
        .padding(.bottom, 5)
    }
}
