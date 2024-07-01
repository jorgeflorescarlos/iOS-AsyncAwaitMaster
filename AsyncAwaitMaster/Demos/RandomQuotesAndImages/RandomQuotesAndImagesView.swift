//
//  RandomQuotesAndImagesView.swift
//  AsyncAwaitMaster
//
//  Created by Jorge Flores Carlos on 30/06/24.
//

import SwiftUI

struct RandomQuotesAndImagesView: View {
    
    @StateObject private var randomImageListVM = RandomImageListViewModel()
    
    var body: some View {
        List {
            Section("Goal") {
                Text("Download a set of quotes and images from different servers using 'withThrowingTaskGroup'")
            }
            Section("Definition") {
                Text("withThrowingTaskGroup is a function provided by Swift’s new concurrency model. It allows you to perform multiple tasks concurrently while also being able to throw errors if needed. It runs a group of tasks in parallel and awaits their completion, returning an array of results or propagating the first thrown error. You can control if the error cancels next tasks in queue or it's fine to continue.")
            }
            Section("Example") {
                ForEach(randomImageListVM.randomImages) { randomImage in
                    randomImage.image.map {
                        QuoteCardView(image: $0, quote: randomImage.quote)
                    }
                }
            }
        }
        .task {
            await randomImageListVM.getRandomImages(ids: Array(100...120))
        }
        .navigationTitle("Random Images/Quotes")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await randomImageListVM.getRandomImages(ids: Array(100...120)) }
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RandomQuotesAndImagesView()
    }
}

struct QuoteCardView: View {
    @State private var background: Color = .white
    var image: UIImage
    var quote: String
    
    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(4/3, contentMode: .fill)
            Text(quote)
                .font(.headline)
                .shadow(color: background.adaptedTextColorInverse, radius: 10)
                .foregroundStyle(background.adaptedTextColor)
                .padding()
                .background(.ultraThinMaterial.opacity(0.5))
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .circular))
        .padding()
        .onAppear {
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0
            image.averageColor?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            let newColor  = UIColor(hue: hue, saturation: 0.9, brightness: brightness, alpha: alpha)
            background = Color(newColor)
        }
        
    }
}

#Preview {
    QuoteCardView(image: UIImage(), quote: "")
}
