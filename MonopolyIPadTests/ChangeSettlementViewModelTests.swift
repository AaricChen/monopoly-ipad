import XCTest
@testable import MonopolyIPad

final class ChangeSettlementViewModelTests: XCTestCase {
    func testIsBalancedWhenPaidMinusReturnedEqualsTarget() {
        let wallet = Wallet(notes: [.m100: 2, .m50: 1, .m10: 1])
        let vm = ChangeSettlementViewModel(targetAmount: 140, initialWallet: wallet)

        vm.moveFromWalletToPaid(.m100)
        vm.moveFromWalletToPaid(.m100)
        vm.moveFromWalletToReturned(.m50)
        vm.moveFromWalletToReturned(.m10)

        XCTAssertTrue(vm.isBalanced)
        XCTAssertEqual(vm.paidTotal, 200)
        XCTAssertEqual(vm.returnedTotal, 60)
    }

    func testWithdrawFailsWhenInsufficientNotes() {
        var wallet = Wallet()
        wallet.deposit(.m10)
        XCTAssertTrue(wallet.withdraw(.m10))
        XCTAssertFalse(wallet.withdraw(.m10))
    }
}
