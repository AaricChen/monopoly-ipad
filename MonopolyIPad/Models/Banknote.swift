import Foundation

/// 纸币面额（单位：游戏币，与实体大富翁面额习惯对齐）
enum Banknote: Int, CaseIterable, Identifiable, Hashable, Codable {
    case m500 = 500
    case m100 = 100
    case m50 = 50
    case m20 = 20
    case m10 = 10
    case m5 = 5
    case m1 = 1

    var id: Int { rawValue }

    var label: String {
        "$\(rawValue)"
    }
}

extension Banknote {
    static func totalAmount(in counts: [Banknote: Int]) -> Int {
        counts.reduce(0) { partial, entry in
            partial + entry.key.rawValue * max(0, entry.value)
        }
    }
}
