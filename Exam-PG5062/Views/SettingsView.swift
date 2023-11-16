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
    
   // private var weatherTxt: String{ colorScheme == .light ? "Light" : "Dark"}
    
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
                Theme.primary.ignoresSafeArea(.all)
                VStack {
                    Text("Select an item").foregroundColor(Theme.text)
                }
                
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
                }
            }
        }
        .preferredColorScheme(selectedScheme) // Set the color scheme here
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
