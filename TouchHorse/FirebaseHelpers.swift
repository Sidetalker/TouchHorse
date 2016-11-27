//
//  FirebaseHelpers.swift
//  TouchHorse
//
//  Created by Kevin Sullivan on 11/27/16.
//  Copyright © 2016 Kevin Sullivan. All rights reserved.
//

import PromiseKit

enum DatabaseReferenceError: Error {
    case timeout
}

extension FIRDatabaseReference {
    
    func set(data: [String : Any]?, timeout: TimeInterval = 30) -> Promise<FIRDatabaseReference> {
        let pending = Promise<FIRDatabaseReference>.pending()
        
        setValue(data) { error, ref in
            if let error = error {
                pending.reject(error)
            } else {
                pending.fulfill(ref)
            }
        }
        
        after(interval: timeout).then { _ -> Void in
            if !pending.promise.isFulfilled {
                pending.reject(DatabaseReferenceError.timeout)
            }
        }.catch { error in
            log.error("Failed to set data: \(error.localizedDescription)")
            log.verbose("Data: \(data)")
            pending.reject(error)
        }
        
        return pending.promise
    }
    
    func remove(withTimeout timeout: TimeInterval = 30) -> Promise<FIRDatabaseReference> {
        return set(data: nil, timeout: timeout)
    }
    
}
