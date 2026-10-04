import Foundation
import Observation

@Observable
final class ChangeSettlementViewModel {
    let targetAmount: Int

    private(set) var wallet: Wallet
    var paidNotes: [Banknote: Int]
    var returnedNotes: [Banknote: Int]

    init(targetAmount: Int, initialWallet: Wallet) {
        self.targetAmount = targetAmount
        self.wallet = initialWallet
        self.paidNotes = [:]
        self.returnedNotes = [:]
    }

    var paidTotal: Int {
        Banknote.totalAmount(in: paidNotes)
    }

    var returnedTotal: Int {
        Banknote.totalAmount(in: returnedNotes)
    }

    /// 支付减找零是否等于应付
    var isBalanced: Bool {
        paidTotal - returnedTotal == targetAmount
    }

    var amountStillDueFromPayer: Int {
        max(0, targetAmount + returnedTotal - paidTotal)
    }

    var overpaidAmount: Int {
        max(0, paidTotal - returnedTotal - targetAmount)
    }

    func moveFromWalletToPaid(_ note: Banknote) {
        guard wallet.withdraw(note) else { return }
        paidNotes[note, default: 0] += 1
    }

    func moveFromPaidToWallet(_ note: Banknote) {
        guard (paidNotes[note] ?? 0) > 0 else { return }
        paidNotes[note, default: 0] -= 1
        if paidNotes[note] == 0 { paidNotes.removeValue(forKey: note) }
        wallet.deposit(note)
    }

    func moveFromWalletToReturned(_ note: Banknote) {
        guard wallet.withdraw(note) else { return }
        returnedNotes[note, default: 0] += 1
    }

    func moveFromReturnedToWallet(_ note: Banknote) {
        guard (returnedNotes[note] ?? 0) > 0 else { return }
        returnedNotes[note, default: 0] -= 1
        if returnedNotes[note] == 0 { returnedNotes.removeValue(forKey: note) }
        wallet.deposit(note)
    }

    func resetSettlement() {
        for (note, count) in paidNotes {
            wallet.deposit(note, count: count)
        }
        for (note, count) in returnedNotes {
            wallet.deposit(note, count: count)
        }
        paidNotes = [:]
        returnedNotes = [:]
    }
}
