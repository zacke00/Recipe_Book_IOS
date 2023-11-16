
                  
import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    @FetchRequest(
        entity: Meal.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Meal.strMeal, ascending: true)]
        // You can add predicates here if you want to filter the results
    )
    private var savedMeals: FetchedResults<Meal>
    
    
    var body: some View {
        ZStack{
            
            Theme.primary.ignoresSafeArea(.all)
            ScrollView {
                ForEach(savedMeals, id: \.self) { meal in
                    Text(meal.strMeal ?? "Unknown Meal")
                    // You can create a custom view to display each meal
                }
            }
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
