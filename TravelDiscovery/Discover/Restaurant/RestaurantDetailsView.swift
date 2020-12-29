//
//  RestaurantDetailsView.swift
//  TravelDiscovery
//
//  Created by Aymen on 26.12.20.
//

import SwiftUI
import KingfisherSwiftUI


struct RestaurantDetails: Decodable {
    let description: String
    let popularDishes: [Dish]
    let photos: [String]
    let reviews: [Review]
}

struct Review: Decodable, Hashable {
    let user: ReviewUser
    let rating: Int
    let text: String
}

struct ReviewUser: Decodable, Hashable {
    let username, firstName, lastName, profileImage: String
}

struct Dish: Decodable, Hashable {
    
    let name: String
    let price: String
    let numPhotos: Int
    let photo: String
}

class RestaurantDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var details: RestaurantDetails?

    init() {
        let id = "0"
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/restaurant?id=\(id.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            //handle error properly
            DispatchQueue.main.async {

                guard  let data = data else { return }
                
                do {
                    self.details = try JSONDecoder().decode(RestaurantDetails.self.self, from: data)
                    
                } catch {
                    debugPrint("Failed to decode JSON:", error)
                }
            }
        }.resume()        
    }
}

struct RestaurantDetailsView: View {
    @ObservedObject var vm = RestaurantDetailsViewModel()

    let restaurant: Restaurant
    
    var body: some View {
        
        ScrollView {
            ZStack(alignment: .bottomLeading) {
                Image(restaurant.imageName)
                    .resizable()
                    .scaledToFill()
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(restaurant.name)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack {
                            ForEach(0..<5, id: \.self) { num in
                                Image(systemName: "star.fill")
                            }
                        }.foregroundColor(.orange )
                    }
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: RestaurantPhotosView(),
                        label: {
                            Text("See more photos")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular))
                                .frame(width: 80)
                                .multilineTextAlignment(.trailing)
                        })
                    
                }.padding()
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Location & Desscription")
                Text("Tokyo, Japan")
                HStack {
                    ForEach(0..<5, id: \.self) { num in
                        Image(systemName: "dollarsign.circle.fill")
                        
                    }.foregroundColor(.orange)
                }
                HStack{
                    Spacer()
                }
            }.padding(.top)
            .padding(.horizontal)
            
            Text(vm.details?.description ?? "")
                .padding(.top, 8)
                .font(.system(size: 14, weight:.regular))
                .padding(.horizontal)
                .padding(.bottom)
            if let reviews = vm.details?.reviews {
                ReviewList(reviews: reviews)
            }
            
        }.navigationBarTitle("Resataurant Details", displayMode: .inline)
    }
    
    
    let sampleDishTitle = [
        "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/c22e8d9e-10f2-4559-8c81-375491295e84", "https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/a4d85eff-4c79-4141-a0d6-761cca48eae1"
    ]
}

struct ReviewList: View {
    
    let reviews: [Review]
    var body: some View {
        HStack {
            Text("Customer reviews")
                .font(.system(size: 16, weight:.bold))
                Spacer()
        }.padding(.horizontal)
            ForEach(reviews, id: \.self) { review in
                VStack(alignment: .leading) {
                    Text(review.text)
                    HStack {
                        KFImage(URL(string: review.user.profileImage))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(review.user.firstName) \(review.user.lastName)")
                                .font(.system(size: 14, weight:.bold))
                           
                            
                            HStack(spacing: 4) {
                                ForEach(0..<review.rating, id: \.self) { review in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                }
                                ForEach(0..<5 - review.rating, id: \.self) { review in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.gray)
                                }
                            }                                            .font(.system(size: 12))

                            
                        }
                        Spacer()
                        Text("Dec 2020")
                            .font(.system(size: 14, weight:.bold))
                    }
                }.padding(.horizontal)
                .padding(.top)
                
            
            }
//        }
    }
}
struct DishCell:View {
    
    let dish: Dish
    var body: some View {
        VStack(alignment: .leading) {
            
            ZStack(alignment: .bottomLeading) {
                KFImage(URL(string: dish.photo))
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .shadow(radius: 2)
                    .padding(.vertical, 2)
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                Text(dish.price)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight:.bold))
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
            }
            .frame(height: 120)
            .cornerRadius(5)


            Text(dish.name)
            Text("\(dish.numPhotos) photos")
                .foregroundColor(.gray)
                .font(.system(size: 12, weight:.regular))
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            RestaurantDetailsView(restaurant: .init(name: "Japan's Finaest Tapas", imageName: "tapas"))
        }
    }
}
