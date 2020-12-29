//
//  DiscoverCategoriesView.swift
//  TravelDiscovery
//
//  Created by Aymen on 23.12.20.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct DiscoverCategoriesView: View {
    
    let categories: [Category] = [
        .init(name: "Art", ImageName: "paintpalette.fill"),
        .init(name: "Sports", ImageName: "sportscourt.fill"),
        .init(name: "Live Events", ImageName: "music.mic"),
        .init(name: "Food", ImageName: "music.mic"),
        .init(name: "History", ImageName: "music.mic")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 14) {
                ForEach(categories, id: \.self, content: { category  in
                    NavigationLink(
                        destination: NavigationLazyView(CategoryDetailsView(name: category.name)),
                        label: {
                            VStack(spacing: 4) {
                                
                                //                        Spacer()
                                Image(systemName: category.ImageName)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color(#colorLiteral(red: 0.9804310203, green: 0.5898955464, blue: 0.2509436011, alpha: 1)))
                                    .frame(width: 64, height: 64)
                                    .background(Color.white)
                                    .cornerRadius(64)
                                //                            .shadow(color: .gray, radius: 4, x: 0.0, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                                Text(category.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                            }.frame(width: 68)                        })
                })
            }.padding(.horizontal)
        }
    }
}

struct DiscoverCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        //        DiscoverCategoriesView()

        
        DiscoverView()
        
        //        NavigationView {
        //            NavigationLink(
        //                destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
        //                label: {
        //                    /*@START_MENU_TOKEN@*/Text("Navigate")/*@END_MENU_TOKEN@*/
        //                })
        //        }
    }
}
