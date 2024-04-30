//
//  ContentView.swift
//  YogaTest
//
//  Created by Calin Gavriliu on 29.04.2024.
//

import SwiftUI

struct Result: Codable {
    var id: Int
    var categoryName: String
    var categoryDescription: String
    var poses: [Pose]

    enum CodingKeys: String, CodingKey {
        case id
        case categoryName = "category_name"
        case categoryDescription = "category_description"
        case poses
    }
}

struct Pose: Codable {
    var id: Int
    var categoryName: String
    var difficultyLevel: String?
    var englishName: String
    var sanskritNameAdapted: String
    var sanskritName: String
    var translationName: String
    var poseDescription: String
    var poseBenefits: String
    var urlSvg: String
    var urlPng: String
    var urlSvgAlt: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryName = "category_name"
        case difficultyLevel = "difficulty_level"
        case englishName = "english_name"
        case sanskritNameAdapted = "sanskrit_name_adapted"
        case sanskritName = "sanskrit_name"
        case poseDescription = "pose_description"
        case translationName = "translation_name"
        case poseBenefits = "pose_benefits"
        case urlSvg = "url_svg"
        case urlPng = "url_png"
        case urlSvgAlt = "url_svg_alt"
    }
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(results, id: \.categoryName) { item in
                    NavigationLink(destination: {
                        PosesView(poses: item.poses)
                    }) {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(item.categoryName)
                                .font(.title2)
                                .fontWeight(.bold)
                            Images(poses: item.poses, spacing: -16, max: 10)
                            
                            Divider()
                            Text(item.categoryDescription)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .foregroundColor(.primary)
                        .padding(32)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.04), radius: 16, y: 12)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                    }
                }
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://yoga-api-nzy4.onrender.com/v1/categories") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error with the response, unexpected status code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                return
            }
            
            let decodedResponse = try JSONDecoder().decode([Result].self, from: data)
            DispatchQueue.main.async {
                results = decodedResponse
            }
        } catch {
            print("Failed to load or decode data with error: \(error)")
        }
    }
}

struct Images: View {
    var poses: [Pose]
    var spacing: CGFloat
    var max: Int
    var body: some View {
        HStack(spacing: spacing) {
            if(poses.count > max) {
                ForEach(poses[0..<max], id:\.englishName) { pose in
                    AsyncImage(url: URL(string: pose.urlPng)) { image in
                        image
                            .resizable()
                            .grayscale(1)
                            .overlay(Color.accentColor.blendMode(.overlay))
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.02), radius: 2, x: -10)
                }
            } else {
                ForEach(poses, id:\.englishName) { pose in
                    AsyncImage(url: URL(string: pose.urlPng)) { image in
                        image
                            .resizable()
                            .grayscale(1)
                            .overlay(Color.accentColor.blendMode(.overlay))
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.02), radius: 2, x: -10)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
