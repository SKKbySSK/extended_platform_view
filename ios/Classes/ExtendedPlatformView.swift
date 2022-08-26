//
//  ExtendedPlatformView.swift
//  extended_platform_view
//
//  Created by 砂賀開晴 on 2022/08/27.
//

import Foundation
import Flutter

public typealias ExtendedPlatformViewBuilder = () -> ExtendedPlatformView

public struct CreationParams {
    public let frame: CGRect
    public let viewId: Int64
    public let args: Any?
}

open class ExtendedPlatformView {
    private (set) public var binaryMessenger: FlutterBinaryMessenger!
    private (set) public var methodChannel: FlutterMethodChannel!
    private (set) public var view: UIView!
    
    public init() {}
    
    func initInternal(messenger: FlutterBinaryMessenger, viewType: String, id: Int64, params: CreationParams) {
        binaryMessenger = messenger
        methodChannel = FlutterMethodChannel(name: "\(viewType)/\(id)/method", binaryMessenger: messenger)
        view = initialize(params: params)
    }
    
    open func initialize(params: CreationParams) -> UIView {
        fatalError("initialize is not implmented")
    }
}

class ExtendedPlatformViewFactoryWrapper: NSObject, FlutterPlatformViewFactory {
    init(messenger: FlutterBinaryMessenger, viewType: String, builder: @escaping ExtendedPlatformViewBuilder) {
        self.messenger = messenger
        self.viewType = viewType
        self.builder = builder
        super.init()
    }
    
    private let messenger: FlutterBinaryMessenger
    private let viewType: String
    private let builder: ExtendedPlatformViewBuilder
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let params = CreationParams(frame: frame, viewId: viewId, args: args)
        let view = builder()
        view.initInternal(messenger: messenger, viewType: viewType, id: viewId, params: params)
        return ExtendedPlatformViewWrapper(view: view)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class ExtendedPlatformViewWrapper: NSObject, FlutterPlatformView {
    init(view: ExtendedPlatformView) {
        platformView = view
        super.init()
    }
    
    private let platformView: ExtendedPlatformView
    
    func view() -> UIView {
        return platformView.view
    }
}
