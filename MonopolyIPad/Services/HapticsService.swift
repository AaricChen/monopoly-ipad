import CoreHaptics
import UIKit

/// 纸币交互与找零成功的触觉反馈（设备不支持时静默降级）
@MainActor
final class HapticsService {
    private var engine: CHHapticEngine?

    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            engine = nil
        }
    }

    func playPickup() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred(intensity: 0.45)
    }

    func playChangeSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine
        else {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            return
        }

        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.55)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.35)
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [intensity, sharpness],
            relativeTime: 0,
            duration: 0.22
        )

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}
