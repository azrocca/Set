//
//  DifficultyMenu.swift
//  Set
//
//  Created by Rocca on 7/16/21.
//

import SwiftUI

struct DifficultyMenu: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("LaunchIcon")
                NavigationLink(destination: GameView(numberOfFeatures: 3)) {
                    DifficultyButton(buttonText: "Easy", textColor: Color.green)
//                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink(destination: GameView(numberOfFeatures: 4)) {
                    DifficultyButton(buttonText: "Medium", textColor: Color.orange)
                }
                NavigationLink(destination: GameView(numberOfFeatures: 5)) {
                    DifficultyButton(buttonText: "Hard", textColor: Color.red)
                }
                
//                Picker("Difficulty", selection: $profile.seasonalPhoto) {
//                    ForEach(Profile.Season.allCases) { season in
//                        Text(season.rawValue).tag(season)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
                
            }
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

struct DifficultyMenu_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyMenu()
    }
}
