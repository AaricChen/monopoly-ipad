# iPad 原生技术方案

## 分层混合架构

```
┌──────────────────────────────────────────────────────────┐
│                   应用层 (UI & 交互)                      │
│   SwiftUI + Observation (@Observable ViewModels)         │
│   钱包抽屉、找零计算器、资产卡片、Pass & Play 遮罩           │
└────────────────────────────┬─────────────────────────────┘
                             │
┌────────────────────────────▼─────────────────────────────┐
│                 表现层 (棋盘、骰子与动效)                  │
│                     SpriteKit (Phase 2+)                 │
│   2D 棋盘、棋子跳跃、骰子物理、纸币曲线/粒子动效              │
└────────────────────────────┬─────────────────────────────┘
                             │
┌────────────────────────────▼─────────────────────────────┐
│                  系统底层 API (硬件增强)                   │
│         CoreHaptics + AVFoundation                       │
└──────────────────────────────────────────────────────────┘
```

## 代码模块（目标结构）

```
MonopolyIPad/
  App/                 # 入口、生命周期、横屏与常亮
  Models/              # Banknote, Wallet, Player…
  ViewModels/          # 找零结算、游戏状态（后续 FSM）
  Views/               # SwiftUI 界面
  Game/                # 规则纯函数、FSM（Phase 2）
  Board/               # SpriteKit 场景（Phase 2）
  Services/            # HapticsService, AudioService
```

## iPad 适配

- **仅横屏**：`Info.plist` / `UISupportedInterfaceOrientations~ipad` 限定 Landscape。
- **沉浸**：根视图 `.persistentSystemOverlays(.hidden)`，减少 Home 指示条干扰。
- **常亮**：`UIApplication.shared.isIdleTimerDisabled = true` 于对局进行中开启。

## MVP 阶段

| 阶段 | 内容 |
|------|------|
| Phase 1 | SwiftUI 钱包/支付/找零、找零校验、Core Haptics 基础反馈 |
| Phase 2 | SpriteKit 环形棋盘、棋子移动、回合 FSM 与 SwiftUI 弹窗衔接 |
| Phase 3 | 机会/命运卡、建房、破产、音效与存档 |

回合状态机与 H5 文档 [07-game-state-machine.md](07-game-state-machine.md) 保持一致语义。
