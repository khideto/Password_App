//
//  Password_AppApp.swift
//  Password_App
//
//  Created by 近藤秀人 on 2023/03/04.
//

import SwiftUI
import Amplify
import AWSDataStorePlugin

@main
struct Password_AppApp: App {
    init() {
        configureAmplify()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func configureAmplify() {
    let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
    do {
        try Amplify.add(plugin: dataStorePlugin)
        try Amplify.configure()
        print("Initialized Amplify");
    } catch {
        // simplified error handling for the tutorial
        print("Could not initialize Amplify: \(error)")
    }
}
