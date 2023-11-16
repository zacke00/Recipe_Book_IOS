//
//  ScrollableCategoryView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 16/11/2023.
//

import SwiftUI

struct ScrollableCategoryView: View {
    var categories: FetchedResults<Category>
    
    var body: some View {
        VStack {
            Text("Categories")
                .frame(height: 30)
                .bold()
                .font(.title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories, id: \.self) { category in
                        CategoryItemView(category: category)
                    }
                }
                .frame(height: 160)
            }
        }
    }
}

struct CategoryItemView: View {
    var category: Category
    
    var body: some View {
        NavigationLink(destination: Text("Category: \(category.strCategory ?? "Unknown")")) {
            ZStack {
                Theme.third
                    .cornerRadius(10)
                    .shadow(color: Theme.shadowColor, radius: 5, x: 0, y: 3) // Add shadow here

                
                VStack {
                    if let categoryName = category.strCategory {
                        if let categoryThumb = category.strCategoryThumb{
                            CustomImageView(urlString: categoryThumb)
                            
                            
                            Text(category.strCategory ?? "unknown")
                                .font(.system(size: 15))
                                .bold()
                                .foregroundColor(Theme.text)
                        }
                    }
                }
                .padding([.top, .bottom], 5)
            }
            .frame(width: 130, height: 120)
            .padding([.leading], 5)
        }
    }
}


