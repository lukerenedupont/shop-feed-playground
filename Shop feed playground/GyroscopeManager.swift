//
//  GyroscopeManager.swift
//  Shop feed playground
//
//  Lightweight CMMotionManager wrapper that exposes device tilt
//  as simple X/Y values suitable for driving parallax effects.
//

import CoreMotion
import SwiftUI

@Observable
final class GyroscopeManager {
    /// Lateral tilt: negative = tilted left, positive = tilted right.
    var tiltX: Double = 0

    /// Depth tilt: negative = tilted toward user, positive = tilted away.
    var tiltY: Double = 0

    private let motion = CMMotionManager()
    private let smoothing: Double = 0.15

    func start() {
        guard motion.isDeviceMotionAvailable else { return }
        motion.deviceMotionUpdateInterval = 1.0 / 60.0
        motion.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
            guard let data, let self else { return }
            let rawX = data.gravity.x
            let rawY = data.gravity.z
            self.tiltX += (rawX - self.tiltX) * self.smoothing
            self.tiltY += (rawY - self.tiltY) * self.smoothing
        }
    }

    func stop() {
        motion.stopDeviceMotionUpdates()
        tiltX = 0
        tiltY = 0
    }
}
