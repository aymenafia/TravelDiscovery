//
//  UserDetailsView.swift
//  TravelDiscovery
//
//  Created by Aymen on 26.12.20.
//

import SwiftUI
import KingfisherSwiftUI

struct UserDetails: Decodable, Hashable {
    
    let username, firstName, lastName, profileImage: String
    let followers, following: Int
    let posts:[Post]
}

struct Post: Decodable, Hashable {
    let title, imageUrl, views: String
    let hashtags: [String]
}

class UserDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var userDetails: UserDetails?

    init(userId: Int) {
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/user?id=\(userId)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            //handle error properly
            DispatchQueue.main.async {

                guard  let data = data else { return }
                
                do {
                    self.userDetails = try JSONDecoder().decode(UserDetails.self.self, from: data)
                    
                } catch let jsonError {
                    debugPrint("Failed to decode JSON:", jsonError)
                }
            }
        }.resume()
        
        
    }
}
struct UserDetailsView: View {
    let user: User
    @ObservedObject var vm: UserDetailsViewModel

    init(user: User) {
        self.user = user
        self.vm = .init(userId: user.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(user.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60)
                    .clipShape(Circle())
                    .clipped()
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .padding(.horizontal)
                    .padding(.top)
                Text("\(self.vm.userDetails?.firstName ?? "") \(self.vm.userDetails?.lastName ?? "")")
                    .font(.system(size: 14, weight: .semibold))
                HStack {
                    Text("\(self.vm.userDetails?.username ?? "")")
                    Image(systemName: "hand.thumbsup.fill")
                    Text("2541 ")
                }
                .font(.system(size: 12, weight: .regular))
                Text("Youtuber. Vlogger. Travel Creator")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.lightGray))
                
                HStack(spacing: 12) {
                    VStack {
                        Text("59,394")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Followers")
                            .font(.system(size: 9, weight: .regular))
                    }
                    Spacer()
                        .frame(width: 1, height: 10)
                        .background(Color(.lightGray))
                    VStack {
                        Text("2,112")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Following")
                            .font(.system(size: 9, weight: .regular))
                    }
                }
                HStack(spacing: 12)  {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        HStack {
                            Spacer()
                            Text("Follow")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }.background(Color.orange)
                        .padding(.vertical, 8)
                        .cornerRadius(100)
                        
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        HStack {
                            Spacer()
                            Text("Contact")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                        }.background(Color(white: 0.9))
                        .padding(.vertical, 8)
                        .cornerRadius(100)
                    })
                }
                ForEach(vm.userDetails?.posts ?? [], id:\.self) { post in
                    VStack(alignment: .leading) {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        HStack {
                            Image(user.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 34)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.system(size: 13, weight: .semibold))
                                
                                Text("\(post.views) views")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }.padding(.horizontal, 8)
                        
                        HStack {
                            ForEach(post.hashtags, id: \.self) { hastagh in
                                
                                Text("#\(hastagh)")
                                    .foregroundColor(Color(#colorLiteral(red: 0.2746231141, green: 0.4371851689, blue: 0.926922977, alpha: 1)))
                                    .padding(6)
                                    .background(Color(#colorLiteral(red: 0.6500352348, green: 0.7459345791, blue: 0.7363574688, alpha: 1)))
                                    .cornerRadius(20)
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }.padding(.bottom)
                        .padding(.horizontal, 8)
                        
                    }
                    //                        .frame(height: 200)
                    .background(Color(white: 1))
                    .cornerRadius(12)
                    .shadow(color: .init(white: 0.8), radius: 5, x: 0, y: 4)
                }
            }.padding(.horizontal)
            
        }.navigationBarTitle("Username", displayMode: .inline)
    }
}
struct DiscoverUserView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDetailsView(user: .init(id: 0, name: "Amy Adams", imageName: "amy"))
        }
    }
}
