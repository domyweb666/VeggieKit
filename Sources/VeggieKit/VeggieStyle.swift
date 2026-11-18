import SwiftUI

/// 共用元件的顏色與字。套件不認得各 app 的色票和字體，由 app 在設定頁外面用 `.veggieStyle(...)` 傳進來；
/// 沒傳就是系統預設。
public struct VeggieStyle {
    public var textPrimary: Color
    public var textSecondary: Color
    public var textTertiary: Color
    /// 列前面的小圖示、開關打開的顏色
    public var accent: Color
    public var destructive: Color
    /// 下一頁（授權、其他 app）的底色
    public var canvas: Color
    /// 下一頁裡卡片的底色
    public var surface: Color
    public var body: Font
    public var headline: Font
    public var subheadline: Font
    public var footnote: Font
    /// 一列的最小高度，也是可以點的高度
    public var rowHeight: CGFloat

    public init(
        textPrimary: Color, textSecondary: Color, textTertiary: Color, accent: Color,
        destructive: Color, canvas: Color, surface: Color, body: Font, headline: Font,
        subheadline: Font, footnote: Font, rowHeight: CGFloat
    ) {
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.accent = accent
        self.destructive = destructive
        self.canvas = canvas
        self.surface = surface
        self.body = body
        self.headline = headline
        self.subheadline = subheadline
        self.footnote = footnote
        self.rowHeight = rowHeight
    }

    public static let system = VeggieStyle(
        textPrimary: .primary, textSecondary: .secondary, textTertiary: Color(uiColor: .tertiaryLabel),
        accent: .accentColor, destructive: .red, canvas: Color(uiColor: .systemGroupedBackground),
        surface: Color(uiColor: .secondarySystemGroupedBackground), body: .body, headline: .headline,
        subheadline: .subheadline, footnote: .footnote, rowHeight: 44
    )
}

/// 間距只有這幾種，共用元件之間對齊用
enum VeggieSpace {
    static let small: CGFloat = 4
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let footer: CGFloat = 24
    /// 列前面圖示佔的寬，字才會對齊成一條線
    static let icon: CGFloat = 24
}

private struct VeggieStyleKey: EnvironmentKey {
    static let defaultValue = VeggieStyle.system
}

public extension EnvironmentValues {
    var veggieStyle: VeggieStyle {
        get { self[VeggieStyleKey.self] }
        set { self[VeggieStyleKey.self] = newValue }
    }
}

public extension View {
    func veggieStyle(_ style: VeggieStyle) -> some View {
        environment(\.veggieStyle, style)
    }
}
