import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            ChangeSettlementView(
                viewModel: ChangeSettlementViewModel(
                    targetAmount: 140,
                    initialWallet: Wallet(notes: [
                        .m500: 1,
                        .m100: 4,
                        .m50: 2,
                        .m20: 3,
                        .m10: 2,
                        .m5: 4,
                        .m1: 10,
                    ])
                )
            )
            .navigationTitle("找零练习")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview("Landscape", traits: .landscapeLeft) {
    RootView()
}
