//
//  Biometric.swift
//  Runner
//
//  Created by nguyentridung on 20/06/2023.
//

import Foundation
import LocalAuthentication

class Biometric {
    
    func checkIsEnroll() -> Dictionary<String, Any> {
        var error: NSError?
        let authContext = LAContext()
        let isEnrolled = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        let evaluatedPolicyDomainStateData = authContext.evaluatedPolicyDomainState
        let base64Data = evaluatedPolicyDomainStateData?.base64EncodedData()
        var token = String(data: base64Data ?? Data(), encoding: .utf8)
        if token == nil {
            token = NSUUID().uuidString
        }
        
        let reason = error?.localizedDescription
        let errorCode = error?.code
        
        var result = Dictionary<String, Any>()
        result = [
            "isEnrolled": isEnrolled,
            "token": token!,
            "reason": reason ?? "",
            "errorCode": errorCode ?? 200
        ]
        
        return result
        
    }
    
}
