//
//  Testing.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 22/11/2023.
//

import SwiftUI

extension String {
    static var alphabeta: [String] {
        var chars = [String]()
        for char in "abcdefghijklmnopqrstuvwxyz".uppercased() {
            chars.append(String(char))
        }
        return chars
    }
}

struct ScrollableIngredientsView: View {
    var ingredients: FetchedResults<Ingredients>
    
    @State private var selectedFirstLetter = "A"
    @State private var scrollViewOffset: CGFloat = 210 // Add this state variable
    @State private var showSaveConfirmation = false

    var body: some View {
        ZStack{
            LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            ScrollViewReader { scrollView in
                
                HStack {
                    List {
                        ForEach(String.alphabeta, id: \.self) { alpha in
                            let filteredIngredients = ingredientsStartingWithLetter(alpha)
                            if !filteredIngredients.isEmpty {
                                Section(header: Text(alpha)) {
                                    ForEach(filteredIngredients, id: \.self) { item in
                                        NavigationLink(destination: MealByIngredients(ingredientName: item.strIngredient!)){
                                            Text("\(item.strIngredient ?? "")")
                                        }
                                    }
                                }.id(alpha)
                            }
                        }.foregroundColor(Theme.text)
                    }
                    .background(LinearGradient(colors: [Theme.primary, Theme.secoundary], startPoint: .top, endPoint: .bottom))
                    .scrollContentBackground(.hidden)
                    
                    VStack {
                        SectionIndexTitles(proxy: scrollView, titles: String.alphabeta, scrollViewOffset: $scrollViewOffset) // Pass scrollViewOffset as a binding
                    }.padding(.trailing, 10)
                    
                }
            }
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity)
    }
    private func ingredientsStartingWithLetter(_ letter: String) -> [Ingredients] {
        return ingredients.filter { ingredient in
            guard let firstLetter = ingredient.strIngredient?.prefix(1).uppercased() else {
                return false
            }
            return firstLetter == letter
        }
    }
   }

    
struct SectionIndexTitles: View {
    let proxy: ScrollViewProxy
    let titles: [String]
    @GestureState private var dragLocation: CGPoint = .zero
    @StateObject var indexState = IndexTitleState()
    @Binding var scrollViewOffset: CGFloat // Add this binding
    
    class IndexTitleState: ObservableObject {
        var currentTitleIndex = 0
        var titleSize: CGSize = .zero
    }
    
    var body: some View {
        VStack {
            ForEach(titles, id: \.self) { title in
                Text(title)
                    .foregroundColor(Theme.third)
                    .modifier(SizeModifier())
                    .onPreferenceChange(SizePreferenceKey.self) {
                        self.indexState.titleSize = $0
                    }
                    .onTapGesture {
                        proxy.scrollTo(title, anchor: .top)
                    }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                    scrollTo(location: state)
                }
        )
    }
    
    private func scrollTo(location: CGPoint) {
            if self.indexState.titleSize.height > 0 {
                let index = Int((location.y - scrollViewOffset) / self.indexState.titleSize.height)
                if index >= 0 && index < titles.count {
                    let selectedTitle = titles[index]

                    // Perform scrolling on the main thread
                    DispatchQueue.main.async {
                        proxy.scrollTo(selectedTitle, anchor: .top)
                    }
                }
            }
        }
}
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        })
    }
}

