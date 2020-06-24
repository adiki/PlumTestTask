//
//  SceneDelegate.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 18/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = RootViewBuilder.makeRootView(
            store: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment(herosProvider: HerosNetworkProvider())
            )
        )

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = DarkHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
