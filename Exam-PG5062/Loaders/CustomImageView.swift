//
//  CustomImageView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 15/11/2023.
//

import SwiftUI

struct CustomImageView: View {
    @State private var loadedImage: UIImage?
    let urlString: String

    var body: some View {
        Group {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        let loader = ImageLoader()
        loader.loadImage(from: urlString) { image in
            self.loadedImage = image
        }
    }
}

struct CustomImageView_Previews: PreviewProvider {
    static var previews: some View {
        CustomImageView(urlString: "https://www.themealdb.com/images/category/seafood.png")
    }
}
