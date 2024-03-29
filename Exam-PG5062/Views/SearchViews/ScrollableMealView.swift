//
//  ScrollableMealView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 16/11/2023.
//

import SwiftUI

struct ScrollableMealView: View {
    var meals: [MealDetails]
    var saveMealAction: (MealDetails) -> Void
    
    @ObservedObject var viewModel: MealViewModel
    
    var body: some View {
        
        ScrollView {
            ForEach(meals, id: \.idMeal) { meal in
                MealItemView(meals: meal, saveMealAction: saveMealAction, viewModel: viewModel).padding([.trailing, .leading], 5)
                    .padding([.top,.bottom],6)
                
            }
            
        }
        
    }
}

struct MealItemView: View {
    var meals: MealDetails
    var saveMealAction: (MealDetails) -> Void
    
    @ObservedObject var viewModel: MealViewModel
    @State private var offset = CGSize.zero
    let maxOffset: CGFloat = 90
    
    var body: some View {
        VStack{
            NavigationLink(destination: displayFocusedMealView(meal: meals, saveMeal: saveMealAction, viewModel: MealViewModel())) {
                ZStack(alignment: .leading) {
                    ZStack(alignment: .trailing){
                        Theme.saveColor
                            .cornerRadius(10)
                            .shadow(color: Theme.shadowColor, radius: 5, x: 0, y: 1)
                        
                        Image(systemName: "archivebox")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .padding(.trailing, 30)
                            .foregroundColor(Theme.ColoredText)
                    }
                    Theme.third
                        .clipShape(RoundedCorner(radius: 10, corner: .topLeft))
                        .clipShape(RoundedCorner(radius: 10, corner: .bottomLeft))
                        .zIndex(1)
                        .frame(width: 100)
                    
                    
                    VStack{
                        
                        CustomImageView(urlString: meals.strMealThumb)
                        
                            .padding()
                        
                        
                    }
                    .zIndex(100)
                    .frame(width: 100)
                    
                    HStack() {
                        VStack{
                            Rectangle()
                                .opacity(0)
                                .frame(width: 100)
                        }
                        ZStack{
                            
                            Theme.secoundary
                                .clipShape(RoundedCorner(radius: 10, corner: .bottomRight))
                                .clipShape(RoundedCorner(radius: 10, corner: .topRight))
                            
                            HStack{
                                Spacer()
                                
                                
                                VStack{
                                    Text(meals.strMeal)
                                        .foregroundColor(Theme.text)
                                        .bold()
                                        .font(.system(size: 24, weight: .bold, design: .default))
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.5)
                                    Spacer()
                                    Text(meals.strCategory ?? "")
                                    
                                    Text(meals.strArea ?? "")
                                    
                                    
                                    
                                }.padding()
                                    .foregroundColor(Theme.text)
                                Spacer()
                                Image(systemName: "chevron.right.2").foregroundColor(Theme.ColoredText)
                                    .padding(.trailing, 5)
                                    .bold()
                            }
                            
                        }
                        .offset(x: min(offset.width, maxOffset), y: 0)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let dragOffset = gesture.translation.width
                                    offset.width = dragOffset > 0 ? min(dragOffset, 0) : max(dragOffset, -maxOffset)
                                    
                                }
                                .onEnded { _ in
                                    if abs(offset.width) == maxOffset {
                                        viewModel.saveMeal(mealDetails: meals)
                                        offset = .zero
                                    } else {
                                        offset = .zero
                                    }
                                }
                        )
                    }
                    
                    
                    
                    
                }
                .frame(width: 340, height: 110)
                
                .padding([.leading,.top], 5)
            }.buttonStyle(FlatLinkStyle())
        }.frame(maxWidth:  .infinity)
    }
}
struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.01 : 1.0) 
            .animation(.spring(), value: configuration.isPressed)
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corner: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

