//
//  Stopwatch.swift
//  Voice Chat
//
//  Created by Eymen Varilci on 22.12.2022.
//

import Foundation

class Stopwatch {
    
    private var startTime : Date?
    
    var elapsedTime: TimeInterval {
        if let startTime = self.startTime {
            return -startTime.timeIntervalSinceNow
        } else {
            return 0
        }
    }
    var isRunning: Bool {
        return startTime != nil
    }
    
    func start() {
        startTime = Date()
    }
    
    func stop() {
        startTime = nil
    }
}
