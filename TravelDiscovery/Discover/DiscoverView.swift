//
//  ContentView.swift
//  TravelDiscovery
//
//  Created by Aymen on 18.12.20.
//

import SwiftUI


extension Color {
    static let discoverBackground = Color(.init(white: 0.95, alpha: 1))
    static let defaultBackground = Color("defaultBackground")
}

struct DiscoverView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9829165339, green: 0.7590389746, blue: 0.1481689273, alpha: 1)), Color(#colorLiteral(red: 0.9805764556, green: 0.5193274681, blue: 0.1396871623, alpha: 1))]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                
                Color.discoverBackground
                    .offset(y: 400)
                ScrollView {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text(" where do you want to go?")
                        Spacer()
                    } .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.init(white: 1, alpha: 0.3)))
                    .cornerRadius(10)
                    .padding(16)
                    
                    DiscoverCategoriesView()
                    VStack {
                        PopularDestinationsView()
                        PopularRestaurantView()
                        TrendingCreatorsView()
                    }

                    .background(Color.defaultBackground)
                    .cornerRadius(16)
                    .padding(.top, 32)
                }.navigationTitle("Discover")
            }
        }
    }
}
//                    .background(colorScheme == .light ? Color.discoverBackground : Color.black)

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .colorScheme(.dark)
        
        DiscoverView()
            .colorScheme(.light)
    }
}

