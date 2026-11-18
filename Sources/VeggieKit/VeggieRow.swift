import SwiftUI

/// 設定頁的一列：圖示＋名稱＋右邊的狀態或箭頭（› 是 app 裡的下一頁，↗ 是跳出 app）。
/// 只畫樣子，點了做什麼由外面包的 Button、Link 決定；外面要掛 `.buttonStyle(.plain)`
public struct VeggieRow: View {
    public enum Accessory {
        case none
        /// app 裡的下一頁
        case push
        /// 跳出 app（瀏覽器、App Store、寄信、系統設定）
        case external
    }

    @Environment(\.veggieStyle) private var style
    let icon: String
    let title: String
    let value: String?
    let accessory: Accessory
    let destructive: Bool

    public init(
        icon: String, title: String, value: String? = nil, accessory: Accessory = .none,
        destructive: Bool = false
    ) {
        self.icon = icon
        self.title = title
        self.value = value
        self.accessory = accessory
        self.destructive = destructive
    }

    public var body: some View {
        HStack(spacing: VeggieSpace.medium) {
            Image(systemName: icon)
                .font(style.body)
                .foregroundStyle(destructive ? style.destructive : style.accent)
                .frame(width: VeggieSpace.icon)
                .accessibilityHidden(true)
            Text(title)
                .font(style.body)
                .foregroundStyle(destructive ? style.destructive : style.textPrimary)
            Spacer(minLength: VeggieSpace.small)
            if let value {
                Text(value)
                    .font(style.body)
                    .foregroundStyle(style.textSecondary)
            }
            accessoryImage
        }
        .frame(minHeight: style.rowHeight)
        .contentShape(Rectangle())
    }

    @ViewBuilder private var accessoryImage: some View {
        switch accessory {
        case .none:
            EmptyView()
        case .push:
            arrow("chevron.right")
        case .external:
            arrow("arrow.up.right")
        }
    }

    private func arrow(_ name: String) -> some View {
        Image(systemName: name)
            .font(style.footnote.weight(.semibold))
            .foregroundStyle(style.textTertiary)
            .accessibilityHidden(true)
    }
}

/// 設定頁的開關列：圖示＋名稱＋開關
public struct VeggieToggleRow: View {
    @Environment(\.veggieStyle) private var style
    let icon: String
    let title: String
    @Binding var isOn: Bool

    public init(icon: String, title: String, isOn: Binding<Bool>) {
        self.icon = icon
        self.title = title
        _isOn = isOn
    }

    public var body: some View {
        HStack(spacing: VeggieSpace.medium) {
            Image(systemName: icon)
                .font(style.body)
                .foregroundStyle(style.accent)
                .frame(width: VeggieSpace.icon)
                .accessibilityHidden(true)
            Toggle(title, isOn: $isOn)
                .font(style.body)
                .foregroundStyle(style.textPrimary)
                .tint(style.accent)
        }
        .frame(minHeight: style.rowHeight)
    }
}
