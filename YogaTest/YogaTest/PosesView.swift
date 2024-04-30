//
//  PosesView.swift
//  YogaTest
//
//  Created by Calin Gavriliu on 29.04.2024.
//

import SwiftUI

struct PosesView: View {
    var poses: [Pose]
    
    var body: some View {
        TabView {
            ForEach(poses, id: \.englishName) { pose in
                VStack(alignment: .leading, spacing: 4) {
                    ZStack {
                        AsyncImage(url: URL(string: pose.urlPng)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .grayscale(1)
                                .overlay(Color.accentColor.blendMode(.overlay))
                        } placeholder: {
                            Color.gray.opacity(0.2)
                                .clipShape(Circle())
                                .scaledToFit()
                        }
                        .padding(32)
//                        .frame(width: 220, height: 220)
//                        .frame(maxWidth: UIScreen.main.bounds.width)
                        
                        Circle()
                            .stroke(Color.primary.opacity(0.1), lineWidth: 16)
//                            .frame(width: 300, height: 300)
                        
                        Circle()
                            .trim(from: 0, to: 0.3)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.degrees(-90))
//                            .frame(width: 300, height: 300)
                    }
                    .padding(36)
                    .background(Color.primary.opacity(0.025))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom, 24)
                    
                    Text(pose.englishName)
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                    Text(pose.sanskritName)
                        .padding(.bottom, 20)
                    Text(pose.poseDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(5)
                    
//                    Text("20s")
//                        .font(.headline)
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 32)
//                        .background(Color.accentColor.opacity(0.2))
//                        .clipShape(Capsule())
//                        .padding(.top, 16)
//                        .padding(.bottom, 28)
                    
//                    ZStack(alignment: .top) {
//                        ScrollView(showsIndicators: false) {
//                            VStack(alignment: .leading) {
//                                Text("""
//""")
//                                Text(pose.poseDescription)
//                                Text("""
//""")
//                            }
//                            .font(.subheadline)
//                        }
//                        .padding(.horizontal, 28)
//                        .padding(.top, 10)
//                        .padding(.bottom, 20)
//                        .background(Color(UIColor.systemBackground))
//                        
//                        VStack {
//                            LinearGradient(colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground), Color(UIColor.systemBackground).opacity(0)], startPoint: .top, endPoint: .bottom).frame(height: 24)
//                            Spacer()
//                            LinearGradient(colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground).opacity(0)], startPoint: .bottom, endPoint: .top).frame(height: 16)
//                        }
//                        .padding(.top, 10)
//                        .padding(.bottom, 20)
//                    }
//                    .cornerRadius(12)
//                    .shadow(color: Color.black.opacity(0.04), radius: 16, y: 8)
                }
                .padding(32)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview {
    PosesView(poses: [
        Pose(
            id: 5,
            categoryName: "Seated Yoga",
            englishName: "Butterfly",
            sanskritNameAdapted: "Baddha Konasana",
            sanskritName: "Baddha Koṇāsana",
            translationName: "baddha = bound, koṇa = angle, āsana = posture",
            poseDescription: "In sitting position, bend both knees and drop the knees to each side, opening the hips.  Bring the soles of the feet together and bring the heels as close to the groin as possible, keeping the knees close to the ground.  The hands may reach down and grasp and maneuver the feet so that the soles are facing upwards and the heels and little toes are connected.  The shoulders should be pulled back and no rounding of the spine.",
            poseBenefits: "Opens the hips and groins.  Stretches the shoulders, rib cage and back.  Stimulates the abdominal organs, lungs and heart.",
            urlSvg: "https://res.cloudinary.com/dko1be2jy/image/upload/fl_sanitize/v1676483074/yoga-api/5_i64gif.svg",
            urlPng: "https://res.cloudinary.com/dko1be2jy/image/upload/fl_sanitize/v1676483074/yoga-api/5_i64gif.png",
            urlSvgAlt: "https://www.dropbox.com/s/3h2pts6xbn28dh7/butterfly%3F.svg?raw=1"
        ),
        
        Pose(
            id: 5,
            categoryName: "Seated Yoga",
            englishName: "Butterfly",
            sanskritNameAdapted: "Baddha Konasana",
            sanskritName: "Baddha Koṇāsana",
            translationName: "baddha = bound, koṇa = angle, āsana = posture",
            poseDescription: "In sitting position, bend both knees and drop the knees to each side, opening the hips.  Bring the soles of the feet together and bring the heels as close to the groin as possible, keeping the knees close to the ground.  The hands may reach down and grasp and maneuver the feet so that the soles are facing upwards and the heels and little toes are connected.  The shoulders should be pulled back and no rounding of the spine.",
            poseBenefits: "Opens the hips and groins.  Stretches the shoulders, rib cage and back.  Stimulates the abdominal organs, lungs and heart.",
            urlSvg: "https://res.cloudinary.com/dko1be2jy/image/upload/fl_sanitize/v1676483074/yoga-api/5_i64gif.svg",
            urlPng: "https://res.cloudinary.com/dko1be2jy/image/upload/fl_sanitize/v1676483074/yoga-api/5_i64gif.png",
            urlSvgAlt: "https://www.dropbox.com/s/3h2pts6xbn28dh7/butterfly%3F.svg?raw=1"
        )
    ])
}
