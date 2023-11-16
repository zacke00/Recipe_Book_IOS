//
//  ScrollableAreaView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 16/11/2023.
//

import SwiftUI

struct ScrollableAreaView: View {
    var area: FetchedResults<Area>

    var body: some View {
        VStack {
            Text("Area")
                .frame(height: 30)
                .bold()
                .font(.title)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(area, id: \.self) { area in
                        AreaItemView(area: area)
                    }
                }
                .frame(height: 160)
            }
        }
    }
}

struct AreaItemView: View {
    var area: Area

    var body: some View {
        NavigationLink(destination: Text("Area: \(area.strArea ?? "Unknown")")) {
            ZStack {
                Theme.third
                    .cornerRadius(10)
                    .shadow(color: Theme.shadowColor, radius: 5, x: 0, y: 3)
                
                VStack {
                    // Replace this with your image loading logic
                    Image(systemName: "circle.fill") // Placeholder image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        

                    Text(area.strArea ?? "unknown")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(Theme.text)
                }
                .padding([.top, .bottom], 5)
            }
            .frame(width: 130, height: 120)
            .padding([.leading], 5)
        }
    
    }
}


