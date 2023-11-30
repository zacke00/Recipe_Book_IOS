

import SwiftUI
import CoreData

struct SavedMeals: View {
    @State private var mealToDelete: Meal?
    @State private var showDeleteAlert = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    @FetchRequest(
        entity: Meal.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.strMeal, ascending: true)]
        // You can add predicates here if you want to filter the results
    )
    private var savedMeals: FetchedResults<Meal>
    
    
    var body: some View {
        NavigationView{
            
            ZStack{
                LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                ScrollView{
                    ForEach(savedMeals, id: \.idMeal){ meal in
                        NavigationLink(destination: displayFocusedFetchedMealView(meal: meal)){
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
                                        
                                        AsyncImageView(url: meal.strMealThumb ?? "")
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 340, height: 200)
                                        .clipShape(RoundedCorner(radius: 20, corner: .topLeft))
                                        .clipShape(RoundedCorner(radius: 20, corner: .topRight))
                                        
                                        VStack{
                                            Text(meal.strMeal ?? "").font(.system(size: 24, weight: .bold, design: .default))
                                            
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
                                                Button {
                                                    mealToDelete = meal
                                                    showDeleteAlert = true
                                                } label: {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.red)
                                                }
                                                .buttonStyle(FlatLinkStyle())
                                                .padding()
                                            }
                                        }.foregroundColor(Theme.ColoredText)
                                        
                                    }
                                    
                                    .padding(.bottom, 10)
                                }
                            }.padding()
                            
                        }
                    }.frame(width: 340)
                        .padding()
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Meal"),
                    message: Text("Are you sure you want to delete this meal?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let meal = mealToDelete {
                            deleteMeal(meal: meal)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            
        }
    }
    func deleteMeal(meal: Meal) {
        viewContext.delete(meal)
        do {
            try viewContext.save()
        } catch {
            // Handle the error, e.g., show an alert
            print("Error deleting meal: \(error)")
        }
    }
}

