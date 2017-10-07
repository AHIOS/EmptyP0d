//
//  SplashManager.swift
//  Pods
//
//  Created by Giuseppe Valenti on 10/7/17.
//
//

import Foundation

public class SplashManager {
    static let sharedInstance = SplashManager()
    
    // MARK: - Properties
    let baseURL: URL

    // Initialization
    
    private init() { //This prevents others from using the default '()' initializer for this class.
        self.baseURL = URL(fileURLWithPath: "")
    }
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
}
