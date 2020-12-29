//
//  DestinationHeaderContainer.swift
//  TravelDiscovery
//
//  Created by Aymen on 25.12.20.
//

import SwiftUI
import KingfisherSwiftUI

struct DestinationHeaderContainer: UIViewControllerRepresentable {
    
    let imageUrlStrings: [String]

    func makeUIViewController(context: Context) -> UIViewController {
        
        let pvc = CustomPageViewController(imageUrlStrings: imageUrlStrings)
        return pvc
    }
    typealias UIViewControllerType = UIViewController
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

class CustomPageViewController: UIPageViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate  {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return allControllers.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = allControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        return allControllers[index - 1]    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = allControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        if index == allControllers.count - 1 {
            return nil
        }
        return allControllers[index + 1]
    }
    
//
//    let firstVC = UIHostingController(rootView: Text("First View"))
//    let secondVC = UIHostingController(rootView: Text("second View"))
//    let thirdVC = UIHostingController(rootView: Text("third View"))
//
//    lazy var allControllers: [UIViewController] = [
//    firstVC, secondVC, thirdVC
//    ]
//
        lazy var allControllers: [UIViewController] = []
    init(imageUrlStrings: [String]) {
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray5
        
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        //pages that we swipe through
        allControllers = imageUrlStrings.map({ imageName in
            let hostingController =
                UIHostingController(rootView:
                                        
                                        KFImage(URL(string: imageName))
                                        .resizable()
                                        .scaledToFill()
                                     
                )
            hostingController.view.clipsToBounds = true
            return hostingController
        })
        
        if let first = allControllers.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
struct DestinationHeaderContainer_Previews: PreviewProvider {
    
    
    static let imageUrlStrings = ["https://letsbuildthatapp-videos.s3.us-west-2.amazonaws.com/7156c3c6-945e-4284-a796-915afdc158b5", "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/b1642068-5624-41cf-83f1-3f6dff8c1702", "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/6982cc9d-3104-4a54-98d7-45ee5d117531"]
    
    static var previews: some View {

        DestinationHeaderContainer(imageUrlStrings:imageUrlStrings)
        .frame(height: 350)
        NavigationView {
            PopularDestiantionDetailsView(destination: .init(name: "Paris", country: "France", imageName: "eiffel_tower",latitude: 48.860139429802935, longitude: 2.2940484446050275))
            
        }
    }
}
