//
//  ContentView.swift
//  WaterCounter
//
//  Created by Hamideh Sheikh on 6/4/22.
//

import SwiftUI

struct ContentView: View {
    @State var progress: CGFloat = 0.5
    @State var startAnimation: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image("0000")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(7)
                        .background(.white, in: Circle())
                    
                    Text("Hamideh")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ZStack {
                        
                        // MARK: water drop
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.white)
                            .scaleEffect(x: 1.1, y:1)
                            .offset(y: -1)
                        
                        // Wave shape
                        WaveShape(progress: progress, waveHeight: 0.1, offset: startAnimation)
                            .fill(Color.blue)
                            .overlay(content: {
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 15, height: 15)
                                        .offset(x: -20, y: 30)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.2))
                                        .frame(width: 25, height: 25)
                                        .offset(x: 20, y: 10)
                                    
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 40, height: 40)
                                        .offset(x: 10, y: 60)
                                }
                            })
                            .mask {
                                Image(systemName: "drop.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                            }
                        
                            .overlay(alignment: .bottom) {
                                Button {
                                    progress += 0.01
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 30, weight: .black))
                                        .foregroundColor(.blue)
                                        .shadow(radius: 2)
                                        .padding()
                                        .background(.white, in: Circle())
                                }
                                .offset(y: 30)
                            }
                    }
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .onAppear {
                        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                            startAnimation = size.width
                        }
                    }
                }
                .frame(height: 350)
                .padding(.top, 100)
                
                Slider(value: $progress)
                    .padding(.top, 100)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(uiColor: .systemGray6))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct WaveShape: Shape {
    var progress: CGFloat
    var waveHeight: CGFloat
    var offset: CGFloat
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: .zero)
            
            // MARK: Drawing wave using sine
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.width, by: 2) {
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: (value + offset)).radians)
                let y: CGFloat = progressHeight + (height * sine)
                
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            // Bottom portion
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
                    
        }
    }
}
