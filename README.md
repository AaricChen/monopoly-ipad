# Monopoly iPad

单设备本地多人（Pass & Play）**iPad 原生**版经典桌游《大富翁》。与 [monopoly-cash-h5](https://github.com/AaricChen/monopoly-cash-h5) 共享产品与规则设计文档思路；本仓库实现 **SwiftUI + SpriteKit** 分层混合架构，突出真实纸币找补、120Hz 动效与 Core Haptics 触觉反馈。

## 技术栈

| 层级 | 选型 | 职责 |
|------|------|------|
| UI 与交互 | SwiftUI + Observation | 钱包抽屉、支付/找零区、资产卡片、设置 |
| 棋盘与动效 | SpriteKit（Phase 2） | 2D 棋盘、棋子、骰子与纸币飞行动画 |
| 硬件增强 | Core Haptics + AVFoundation | 触觉与音效（Phase 1 起逐步接入） |

详细架构见 [docs/08-ipad-native-stack.md](docs/08-ipad-native-stack.md)。

## 文档（与 H5 设计对齐）

| 文档 | 说明 |
|------|------|
| [iPad 原生技术方案](docs/08-ipad-native-stack.md) | 分层架构、模块划分、MVP 阶段 |
| [产品概述](docs/01-product-overview.md) | 愿景、目标用户、核心亮点 |
| [纸币与结算系统](docs/02-cash-settlement-system.md) | 面额、找零校验、练习模式 |
| [Pass & Play 与 UI](docs/03-pass-and-play-ui.md) | 同屏交接、平板横屏布局 |
| [MVP 路线图](docs/06-mvp-roadmap.md) | Phase 1–3 交付范围 |

## 开发

```bash
# 生成 Xcode 工程（需 XcodeGen: brew install xcodegen）
xcodegen generate

open MonopolyIPad.xcodeproj
```

在 Xcode 中选择 **iPad** 模拟器或真机，横屏运行。Phase 1 入口为找零练习界面。

### 测试

```bash
xcodebuild test \
  -project MonopolyIPad.xcodeproj \
  -scheme MonopolyIPad \
  -destination 'platform=iOS Simulator,name=iPad Pro 13-inch (M5)' \
  -quiet
```

## 当前版本

**v0.1.0** — 工程骨架、纸币/钱包模型、找零结算 ViewModel 与 SwiftUI 练习界面；SpriteKit 棋盘与完整规则待 Phase 2–3。

## 许可证

代码与文档许可证待定。Classic Monopoly 品牌与规则版权归 Hasbro 等权利人所有；本项目为独立学习向实现，正式发行需另行取得授权。
