//
//  SamplePlatformView.swift
//  Runner
//
//  Created by 砂賀開晴 on 2022/08/27.
//

import Foundation
import UIKit
import extended_platform_view

class SamplePlatformView: ExtendedPlatformView {
    override func initialize(params: CreationParams) -> UIView {
        let label = UILabel(frame: params.frame)
        label.text = (params.args as! String)
        
        methodChannel.setMethodCallHandler({ call, result in
            switch call.method {
            case "set_text":
                label.text = (call.arguments as! String)
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        return label
    }
}
