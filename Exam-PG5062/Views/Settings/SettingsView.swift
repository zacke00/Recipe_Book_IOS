//
//  SettingsView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 15/11/2023.
//

import SwiftUI
enum Theme {
    
    static let primary = Color("primaryBodyColor")
    static let secoundary = Color("secoundaryBodyColor")
    static let third = Color("thirdBodyColor")
    static let text = Color("textColor")
    static let ColoredText = Color("coloredText")
    static let shadowColor = Color("shadowColor")
    static let saveColor = Color("saveColor")
    static let ButtonColor = Color("ButtonColor")
}

enum SchemeType:Int, Identifiable, CaseIterable {
    var id: Self {self}
    case light
    case dark
}

extension SchemeType {
    var title: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}

struct SettingsView: View {
    @AppStorage("systemThemeVal") private var systemTheme: Int = SchemeType.allCases.first!.rawValue
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isPressed = false
    
    private var selectedScheme: ColorScheme? {
        guard let theme = SchemeType(rawValue: systemTheme) else { return nil}
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        default: return nil
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                VStack {
                    
                    
                    VStack {
                        Toggle(isOn: Binding(
                            get: { systemTheme == SchemeType.dark.rawValue },
                            set: { newValue in
                                systemTheme = newValue ? SchemeType.dark.rawValue : SchemeType.light.rawValue
                            }
                        )) {
                            Text("Dark Mode")
                        }
                        .padding()
                        
                        NavigationLink(destination: EditSavedMealsView()) {
                            Text("Edit Saved Meals")
                                .buttonStyle(FlatLinkStyle())
                                .frame(minWidth: 0, maxWidth: 300)
                                .padding()
                                .background(Theme.ButtonColor)
                                .foregroundColor(Theme.text)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        
                        Button{
                            MealCache.shared.clearCache()
                        }label: {
                            Text("Clear Cache")
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
                    
                    
                }
            }
            .preferredColorScheme(selectedScheme)
        }
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
