//
//  DisplayMealView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 23/11/2023.
//

import SwiftUI

struct DisplayMealView: View {
    var meal: MealDetails
    @ObservedObject var viewModel: MealViewModel
    @State private var loadedImage: UIImage?
    
    var body: some View {
        
        VStack{
            
            ZStack(alignment: .top){
                Rectangle()
                
                    .cornerRadius(20)
                    .foregroundColor(Theme.primary)
                    .padding(0)
                    .shadow(color: Theme.shadowColor, radius: 5, x:5, y:5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Theme.third, lineWidth: 2)
                    )
                
                HStack(alignment: .top, spacing: 0){
                    VStack{
                        if let image = loadedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 340, height: 200)
                                .clipShape(Rectangle())
                                .clipShape(RoundedCorner(radius: 20, corner: .topLeft))
                                .clipShape(RoundedCorner(radius: 20, corner: .topRight))
                            
                        } else {
                            ProgressView()
                                .onAppear {
                                    loadImage()
                                }
                        }
                        VStack{
                            Text(meal.strMeal).font(.system(size: 24, weight: .bold, design: .default))
                            
                            HStack{
                                Spacer()
                                VStack{
                                    Text(meal.strTags ?? "")
                                    
                                }
                                Spacer()
                                VStack{
                                    Text(meal.strArea ?? "")
                                    Text(meal.strCategory ?? "")
                                }
                                Spacer()
                                
                            }
                        }.foregroundColor(Theme.ColoredText)
                        
                    }
                    
                    .padding(.bottom, 10)
                }
            }
        }.frame(width: 340)
            .padding()
        
        
        
    }
    private func loadImage() {
        let loader = ImageLoader()
        loader.loadImage(from: meal.strMealThumb) { image in
            self.loadedImage = image
        }
    }
}


struct displayFocusedMealView: View{
    var meal: MealDetails
    var saveMeal: (MealDetails) -> Void
    @State var showSaveConfirmation = false
    @ObservedObject var viewModel: MealViewModel
    
    var body: some View{
        ZStack{
            LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            
            ScrollView{
                
                VStack{
                    ZStack{
                        
                        Theme.third
                            .frame(width: 310,height: 250)
                            .cornerRadius(10)
                        CustomImageBigView(urlString: meal.strMealThumb)
                            
                    }
                    HStack{
                        Spacer()
                        VStack{
                            Text(meal.strMeal)
                                .font(.title)
                                .bold()
                                .padding()
                                .foregroundColor(Theme.ColoredText)
                            Text(meal.strCategory ?? "")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Theme.ColoredText)
                        }.padding(.leading, 30)
                        Spacer()
                        
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .frame(width: 20,height: 25)
                            .onTapGesture {
                                viewModel.saveMeal(mealDetails: meal)
                                
                            }
                            .foregroundColor(Theme.ColoredText)
                            .padding(.trailing, 10)
                        
                    }
                    VStack{
                        
                        VStack(alignment: .leading){
                            Text("Measurements")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Theme.ColoredText)
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                                .foregroundColor(.gray)
                            VStack(alignment: .leading){
                                ForEach(meal.measurements, id: \.self){Measurement in
                                    Text(Measurement)
                                }
                            }
                            .padding(.bottom, 20)
                            
                            
                            
                            Text("Instructions")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Theme.ColoredText)
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                                .foregroundColor(.gray)
                            Text(meal.strInstructions ?? "No instructions")
                        }
                    }
                }
            }
            if viewModel.showSaveConfirmation {
                SaveConfirmationView()
                    .transition(.move(edge: .top)) // For slide-in animation
                    .zIndex(1)
                    .position(x: UIScreen.main.bounds.width / 2, y: 40) // Adjust position as needed
                    .animation(.easeOut, value: showSaveConfirmation)
            }
        }
    }
    
    
}



struct DisplayFetchedMealView: View {
    var meal: Meal
    @ObservedObject var viewModel: MealViewModel
    @State private var loadedImage: UIImage?
    
    var body: some View {
        
        VStack{
            
            ZStack(alignment: .top){
                Rectangle()
                
                    .cornerRadius(20)
                    .foregroundColor(Theme.primary)
                    .padding(0)
                    .shadow(color: Theme.shadowColor, radius: 5, x:5, y:5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Theme.third, lineWidth: 2)
                    )
                
                HStack(alignment: .top, spacing: 0){
                    VStack{
                        if let image = loadedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 340, height: 200)
                                .clipShape(Rectangle())
                                .clipShape(RoundedCorner(radius: 20, corner: .topLeft))
                                .clipShape(RoundedCorner(radius: 20, corner: .topRight))
                            
                        } else {
                            ProgressView()
                                .onAppear {
                                    loadImage()
                                }
                        }
                        VStack{
                            Text(meal.strMeal!).font(.system(size: 24, weight: .bold, design: .default))
                            
                            HStack{
                                Spacer()
                                VStack{
                                    Text(meal.strTags ?? "")
                                    
                                }
                                Spacer()
                                VStack{
                                    Text(meal.area?.strArea ?? "")
                                    Text(meal.category?.strCategory ?? "")
                                }
                                Spacer()
                                
                            }
                        }.foregroundColor(Theme.ColoredText)
                        
                    }
                    
                    .padding(.bottom, 10)
                }
            }
        }.frame(width: 340)
            .padding()
        
        
        
    }
    private func loadImage() {
        let loader = ImageLoader()
        loader.loadImage(from: meal.strMealThumb ?? "") { image in
            self.loadedImage = image
        }
    }
}


struct displayFocusedFetchedMealView: View{
    var meal: Meal
    
    
    var body: some View{
        ZStack{
            LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            
            ScrollView{
                
                VStack{
                    ZStack{
                        
                        Theme.third
                            .frame(width: 310,height: 250)
                            .cornerRadius(10)
                        CustomImageBigView(urlString: meal.strMealThumb ?? "")
                    }
                    HStack{
                        Spacer()
                        VStack{
                            Text(meal.strMeal!)
                                .font(.title)
                                .bold()
                                .padding()
                                .foregroundColor(Theme.ColoredText)
                            Text(meal.category?.strCategory ?? "")
                                .bold()
                                .font(.title3)
                                .foregroundColor(Theme.ColoredText)
                        }.padding(.leading, 30)
                        Spacer()
                        
                        
                        
                    }
                    VStack(alignment: .leading) {
                        Text("Measurements")
                            .bold()
                            .font(.title3)
                            .foregroundColor(Theme.ColoredText)
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            ForEach(meal.measurements?.allObjects as? [Measurements] ?? [], id: \.self) { measurement in
                                if let ingredient = measurement.strIngredients, let measure = measurement.strMeasure {
                                    Text("\(ingredient): \(measure)")
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                    
                    
                    Text("Instructions")
                        .bold()
                        .font(.title3)
                        .foregroundColor(Theme.ColoredText)
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .foregroundColor(.gray)
                    Text(meal.strInstructions ?? "No instructions")
                }
            }
        }
    }
}




