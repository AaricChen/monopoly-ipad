import Foundation

/// 玩家持有的纸币库存
struct Wallet: Equatable, Codable {
    var notes: [Banknote: Int]

    init(notes: [Banknote: Int] = [:]) {
        self.notes = notes
    }

    var totalAmount: Int {
        Banknote.totalAmount(in: notes)
    }

    mutating func deposit(_ note: Banknote, count: Int = 1) {
        guard count > 0 else { return }
        notes[note, default: 0] += count
    }

    mutating func withdraw(_ note: Banknote, count: Int = 1) -> Bool {
        guard count > 0, (notes[note] ?? 0) >= count else { return false }
        notes[note, default: 0] -= count
        if notes[note] == 0 { notes.removeValue(forKey: note) }
        return true
    }

    func count(of note: Banknote) -> Int {
        notes[note] ?? 0
    }
}
