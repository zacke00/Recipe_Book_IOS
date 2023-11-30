
import SwiftUI
import UIKit

@main
struct Exam_PG5062App: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("systemThemeVal") private var systemTheme: Int = SchemeType.allCases.first!.rawValue
    @State private var showAnimation = true

    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    init() {
        let tabBarAppearance = UITabBarAppearance()
        
        // Create a blur effect
        let blurEffect = UIBlurEffect(style: .systemMaterial) // Choose the blur style you prefer
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        // Set the blur effect as the background
        tabBarAppearance.backgroundEffect = blurEffect

        // Apply the appearance to both standard and scroll edge appearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    var body: some Scene {
        WindowGroup {
            TabView{
                
                    
                    
                MainView()
                        .preferredColorScheme(systemTheme == SchemeType.dark.rawValue ? .dark : .light)
                        .tabItem {
                            Label("Discovery", systemImage: "homekit")
                        }
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                       
              
                SearchView()
                    .preferredColorScheme(systemTheme == SchemeType.dark.rawValue ? .dark : .light)
                    .tabItem {
                        Label("search", systemImage: "magnifyingglass.circle.fill")
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                SavedMeals()
                    .preferredColorScheme(systemTheme == SchemeType.dark.rawValue ? .dark : .light)
                    .tabItem {
                        Label("Saved", systemImage: "tray.full")
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                
                SettingsView()
                    .preferredColorScheme(systemTheme == SchemeType.dark.rawValue ? .dark : .light)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
            }
            .onAppear{
                
               
                
                if !hasLaunchedBefore{
                    APIClient().fetchSequentially()
                    hasLaunchedBefore = true
                }
            }
        }
    }
}
