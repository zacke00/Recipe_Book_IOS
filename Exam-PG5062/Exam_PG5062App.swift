
import SwiftUI
import UIKit

@main
struct Exam_PG5062App: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("systemThemeVal") private var systemTheme: Int = SchemeType.allCases.first!.rawValue
    
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    
    var body: some Scene {
        WindowGroup {
            TabView{
                
                
                       
                ContentView()
                    .preferredColorScheme(systemTheme == SchemeType.dark.rawValue ? .dark : .light)
                    .tabItem {
                        Label("Data", systemImage: "square.stack.3d.up").background(.tint)
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                SearchView(areaDemo: [])
                    .preferredColorScheme(systemTheme == SchemeType.dark.rawValue ? .dark : .light)
                    .tabItem {
                        Label("search", systemImage: "magnifyingglass.circle.fill")
                    }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
                SettingsView()
                    .preferredColorScheme(systemTheme == SchemeType.dark.rawValue ? .dark : .light)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .onAppear{
                
                UITabBar.appearance().unselectedItemTintColor = .gray
                
                if !hasLaunchedBefore{
                    APIClient().fetchSequentially()
                    hasLaunchedBefore = true
                }
            }
        }
    }
}
