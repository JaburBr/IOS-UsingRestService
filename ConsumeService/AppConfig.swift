//
//  AppConfig.swift
//  ConsumeService
//
//  Created by Leandro Jabur on 12/6/17.
//  Copyright © 2017 Leandro Jabur. All rights reserved.
//

import Foundation
import SystemConfiguration

struct Config {
    
    static let clientId = "HNyVkHsgZjnEpx4ZKbRpSKUwBa5soEeVmIBiYzGO"
    
    static let clientSecret = "vPJclGVdy6OC6gxmvqFDd6vuOiNnno5G5I43VgTBPKHBlb1v6XpYZrX7Hu9izUU5IjpGH8KIr8aUYGdn1s78xWP12F8H9ZeFqHIF2obRnH9wzCkHBZo3DDICFgbsPIwb"
    
    static let grantTypePassword = "password"
    static let kHttpEndpoint = "http://localhost:8000/api"
    static let token = "token"
    static let expiration = "expiration"
    
}

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
