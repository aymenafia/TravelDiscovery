//
//  PopularDestinationsView.swift
//  TravelDiscovery
//
//  Created by Aymen on 23.12.20.
//

import SwiftUI
import MapKit

struct PopularDestinationsView: View {
    
    let destinations: [Destination] = [
        .init(name: "Paris", country: "France", imageName: "eiffel", latitude: 48.859565, longitude: 2.353235),
        .init(name: "Tokyo", country: "Japan", imageName: "japan", latitude: 35.679693, longitude: 139.771913),
        .init(name: "New York", country: "USA", imageName: "newyork", latitude: 40.71592, longitude: -74.0055),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Popular Destination")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }.padding(.horizontal)
            .padding(.top)
            
        }
        
        ScrollView(.horizontal, showsIndicators: false)  {
            HStack(spacing: 8) {
                
                ForEach(destinations, id: \.self, content: { destination  in
                    NavigationLink(
                        destination: NavigationLazyView(PopularDestiantionDetailsView(destination: destination)),
                        label: {
                            PopularDestinationTile(destination: destination)
                                
                                .padding(.bottom)
                        })
                    
                })
            }.padding(.horizontal)
        }
    }
}

struct DestinationDetails: Decodable {
    let description: String
    let photos: [String]
}


class DestinationDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetails?

    init(name: String) {
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

                guard  let data = data else { return }
                
                do {
                    self.destinationDetails = try JSONDecoder().decode(DestinationDetails.self.self, from: data)
                    
                } catch {
                    debugPrint("Failed to decode JSON:", error)
                }
            }
        }.resume()
        
        
    }
}


struct PopularDestiantionDetailsView: View {
    @ObservedObject var vm: DestinationDetailsViewModel
    
    let destination: Destination
    
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = true
    
    init(destination: Destination) {
        self.destination = destination
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        self.vm = .init(name: destination.name)
    }
    
    let imageUrlString = ["https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/7156c3c6-945e-4284-a796-915afdc158b5", "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/b1642068-5624-41cf-83f1-3f6dff8c1702", "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/6982cc9d-3104-4a54-98d7-45ee5d117531"]
    var body: some View {
        ScrollView {
            
            if let photos = vm.destinationDetails?.photos {
                DestinationHeaderContainer(imageUrlStrings: photos)
                    .frame(height: 350)

            }

//            Image(destination.imageName)
//                .resizable()
//                .scaledToFill()
//                .clipped()
            
            VStack(alignment: .leading) {
                Text(destination.name)
                    .font(.system(size: 18, weight: .semibold))
                
                Text(destination.country)
                
                HStack {
                    ForEach(0..<5,id:\.self) {  num in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }.padding(.top, 2)
                
           
                HStack {
                    Text(vm.destinationDetails?.description ?? "")
                        
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal)
            
            HStack {
                Text("location")
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                Button(action: {isShowingAttractions.toggle()}, label: {
                    Text("\(isShowingAttractions ? "Hide" : "Show") Attraction")
                        .font(.system(size: 12, weight: .semibold))
                })
                Toggle("Title Title", isOn: $isShowingAttractions)
                    .labelsHidden()
            }.padding(.horizontal)
            
            //            Map(coordinateRegion: $region)
            
            //                .frame(height: 300)
            
            
            Map(coordinateRegion: $region, annotationItems: isShowingAttractions ? attractions : []) { attraction in
                //                 MapMarker(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude), tint: .orange)
                
                MapAnnotation(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude)) {
                    CustomMapAnnotation(attraction: attraction)
                }
            }
            .frame(height: 300)
            
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }
    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", imageName: "eiffel_tower", latitude: 48.858605, longitude: 2.2946),
        .init(name: "Champs-Elysees", imageName: "new_york", latitude: 48.866867, longitude: 2.311780),
        .init(name: "Louvre Museum", imageName: "art2", latitude: 48.860288, longitude: 2.337789)
    ]
    
}
struct CustomMapAnnotation: View {
    
    let attraction: Attraction
    
    var body: some View {
        
        VStack {
            Image(attraction.imageName)
                .resizable()
                .frame(width: 80, height: 60)
            Text(attraction.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.init(white: 0, alpha: 0.3)))
                )
        }
        .shadow(radius: 5)
    }
}

struct Attraction: Identifiable {
    let id = UUID().uuidString
    let name, imageName: String
    let latitude, longitude: Double
}


struct PopularDestinationTile: View {
    
    let destination: Destination
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                //                            .clipped()
                .cornerRadius(5)
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
            
            Text(destination.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .foregroundColor(Color(.label))
            Text(destination.country)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal,12)
                .padding(.bottom, 8)
                .foregroundColor(.gray)
        }
        
        .frame(width: 125)
        .asTile()
    }
    
}


struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            PopularDestiantionDetailsView(destination: .init(name: "Paris", country: "France", imageName: "eiffel_tower",latitude: 48.860139429802935, longitude: 2.2940484446050275))
            
        }
        PopularDestinationsView()
        DiscoverView()
    }
}
