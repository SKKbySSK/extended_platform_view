//
//  ExtendedPlatformViewRegistrar.swift
//  extended_platform_view
//
//  Created by 砂賀開晴 on 2022/08/27.
//

import Foundation

public class ExtendedPlatformViewRegistrar {
    static var registeredViews: [String: ExtendedPlatformViewBuilder] = [:]
    
    public static func register(viewType: String, builder: @escaping ExtendedPlatformViewBuilder) {
        registeredViews[viewType] = builder
    }
}
