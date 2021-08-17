//
//  DifficultyMenu.swift
//  Set
//
//  Created by Rocca on 7/16/21.
//

import SwiftUI

struct DifficultyMenu: View {
    
    enum Difficulty: Int, CaseIterable, CustomStringConvertible {
//        case easy, medium, hard
        case easy = 3, medium, hard
        
        var description: String {
            switch self {
            case .easy:
                return "easy"
            case .medium:
                return "medium"
            case .hard:
                return "hard"
            }
        }
    }
    
    @State var difficulty: Difficulty = .easy
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Image("LaunchIcon")
                        .padding(.top)
                    Text("Select a difficulty")
                    Picker("Difficulty", selection: $difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.description.capitalized).tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, geometry.size.width * 0.1)
                    NavigationLink(destination: GameView(numberOfFeatures: difficulty.rawValue)) {
                        playButton
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.5)
                            .padding(.top)
                    }
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    let buttonShape = RoundedRectangle(cornerRadius: 5.0)
    
    var playButton: some View {
        HStack {
            Spacer()
            HStack {
                Text("Play Game")
                    .foregroundColor(DrawingConstants.buttonTextColor)
                Image(systemName: "play.fill")
                    .foregroundColor(DrawingConstants.buttonTextColor)
            }
            .padding()
            .background(buttonShape)
            Spacer()
        }
    }
    
    private func calculateFontSize(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * 0.4)
    }
    
    init() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    struct DrawingConstants {
        static let buttonTextColor = Color.white
        static let buttonBackgroundColor = Color.blue
    }
}

//extension UINavigationController: UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}

struct DifficultyMenu_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyMenu()
    }
}
