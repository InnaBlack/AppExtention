//
//  File.swift
//  AppExtention
//
//  Created by  inna on 03/03/2021.
//

import Foundation

typealias DispatcherIdentifier = String

final class ShedulerGCD {
    
    static let shared: ShedulerGCD = .init()
    
    private var items: [DispatcherIdentifier: DispatchWorkItem] = .init()
    
    private let queue: DispatchQueue
    
    deinit {
        cancelAllActions()
    }
    
    init(_ queue: DispatchQueue = .main) {
        self.queue = queue
    }
        
    func schedule(
                  with identifier: DispatcherIdentifier,
                  action: @escaping () -> Void) {
        cancelAction(with: identifier)
        
        print("Scheduled work item \(identifier)")
        let item = DispatchWorkItem(block: action)
        items[identifier] = item
    }
    
    @discardableResult
    func cancelAction(with identifier: DispatcherIdentifier) -> Bool {
        guard let item = items[identifier] else {
            return false
        }
        
        defer {
            items[identifier] = nil
        }
        
        guard !item.isCancelled else {
            return false
        }
        
        item.cancel()
        print("Cancelled \(identifier)")
        
        return true
    }
    
    
    @discardableResult
    func pausedAction(with identifier: DispatcherIdentifier) -> Bool {
        guard let item = items[identifier] else {
            return false
        }
        
        item.wait()
        print("Paused \(identifier)")
        
        return true
    }
    
    @discardableResult
    func startAction(with identifier: DispatcherIdentifier, on queue: DispatchQueue? = nil) -> Bool {
        guard let item = items[identifier] else {
            return false
        }
        (queue ?? self.queue).asyncAfter(deadline: .now(), execute: item)
        
        print("Start \(identifier)")
        
        return true
    }
    
    func pausedAll() {
        items.keys.forEach {
            items[$0]?.wait()
        }
    }
    
    func cancelAllActions() {
        items.keys.forEach {
            items[$0]?.cancel()
            items[$0] = nil
        }
    }
    
    func startAll() {
        items.keys.forEach {
            items[$0]?.perform()
        }
    }
    
}
