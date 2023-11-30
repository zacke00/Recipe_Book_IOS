//
//  AsyncImageView.swift
//  Exam-PG5062
//
//  Created by zakaria berglund on 29/11/2023.
//

import SwiftUI

struct AsyncImageView: View {
    let url: String
    @State private var loadedImage: UIImage?

    var body: some View {
        if let image = loadedImage {
            Image(uiImage: image)
                .resizable()
                
        } else {
            ProgressView()
                .onAppear {
                    loadImage()
                }
        }
    }

    private func loadImage() {
        ImageLoader().loadImage(from: url) { image in
            self.loadedImage = image
        }
    }
}
