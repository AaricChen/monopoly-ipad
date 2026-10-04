import SwiftUI

struct ChangeSettlementView: View {
    @Bindable var viewModel: ChangeSettlementViewModel
    private let haptics = HapticsService()

    var body: some View {
        HStack(spacing: 24) {
            settlementColumn(
                title: "钱包",
                subtitle: "合计 \(viewModel.wallet.totalAmount)",
                counts: viewModel.wallet.notes,
                emptyHint: "暂无纸币"
            ) { note in
                viewModel.moveFromWalletToPaid(note)
                haptics.playPickup()
            }

            settlementColumn(
                title: "支付区",
                subtitle: "已付 \(viewModel.paidTotal)",
                counts: viewModel.paidNotes,
                emptyHint: "从钱包点选面额"
            ) { note in
                viewModel.moveFromPaidToWallet(note)
                haptics.playPickup()
            }

            VStack(spacing: 12) {
                statusPanel
                settlementColumn(
                    title: "找零区",
                    subtitle: "找回 \(viewModel.returnedTotal)",
                    counts: viewModel.returnedNotes,
                    emptyHint: "从钱包放入找零"
                ) { note in
                    viewModel.moveFromReturnedToWallet(note)
                    haptics.playPickup()
                }
                walletQuickReturnButtons
            }
        }
        .padding(24)
        .onChange(of: viewModel.isBalanced) { _, balanced in
            if balanced { haptics.playChangeSuccess() }
        }
    }

    private var statusPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("应付 \(viewModel.targetAmount)")
                .font(.title2.bold())
            if viewModel.isBalanced {
                Label("找零正确", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.headline)
            } else if viewModel.overpaidAmount > 0 {
                Text("还需找零 \(viewModel.overpaidAmount)")
                    .foregroundStyle(.orange)
            } else {
                Text("还差 \(viewModel.amountStillDueFromPayer)")
                    .foregroundStyle(.secondary)
            }
            Button("清空支付与找零") {
                viewModel.resetSettlement()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var walletQuickReturnButtons: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("快捷：从钱包放入找零区")
                .font(.caption)
                .foregroundStyle(.secondary)
            FlowBanknotePicker(notes: Banknote.allCases) { note in
                guard viewModel.wallet.count(of: note) > 0 else { return }
                viewModel.moveFromWalletToReturned(note)
                haptics.playPickup()
            } label: { note, available in
                Text(note.label)
                    .font(.subheadline.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(available ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.15))
                    .clipShape(Capsule())
            } isEnabled: { note in
                viewModel.wallet.count(of: note) > 0
            }
        }
    }

    private func settlementColumn(
        title: String,
        subtitle: String,
        counts: [Banknote: Int],
        emptyHint: String,
        onTap: @escaping (Banknote) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            ScrollView {
                LazyVStack(spacing: 8) {
                    let sorted = counts.sorted { $0.key.rawValue > $1.key.rawValue }
                    if sorted.isEmpty {
                        Text(emptyHint)
                            .foregroundStyle(.tertiary)
                            .frame(maxWidth: .infinity, minHeight: 120)
                    } else {
                        ForEach(sorted, id: \.key) { note, count in
                            Button {
                                onTap(note)
                            } label: {
                                HStack {
                                    Text(note.label)
                                        .font(.title3.bold())
                                    Spacer()
                                    Text("×\(count)")
                                        .monospacedDigit()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

/// 简单流式面额按钮（Phase 1 占位，后续改为拖拽）
private struct FlowBanknotePicker<Label: View>: View {
    let notes: [Banknote]
    let action: (Banknote) -> Void
    @ViewBuilder let label: (Banknote, Bool) -> Label
    let isEnabled: (Banknote) -> Bool

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(notes) { note in
                Button {
                    action(note)
                } label: {
                    label(note, isEnabled(note))
                }
                .disabled(!isEnabled(note))
            }
        }
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                proposal: ProposedViewSize(frame.size)
            )
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var frames: [CGRect] = []

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), frames)
    }
}

#Preview("Landscape", traits: .landscapeLeft) {
    ChangeSettlementView(
        viewModel: ChangeSettlementViewModel(
            targetAmount: 140,
            initialWallet: Wallet(notes: [.m100: 2, .m20: 1])
        )
    )
}
