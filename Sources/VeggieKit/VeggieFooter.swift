import SwiftUI
import UIKit

/// 設定頁最下面：app 圖示、版本號、Made by DOMYWEB、網站和社群連結。長按版本號複製版本資訊，回報問題時用
public struct VeggieFooter: View {
    @Environment(\.veggieStyle) private var style
    let config: VeggieConfig
    let logo: Image
    /// 複製好之後請設定頁跳一句提示
    let show: (String) -> Void

    private let logoSide: CGFloat = 64
    private let logoRadius: CGFloat = 14
    private let brandIconSide: CGFloat = 26

    public init(config: VeggieConfig, logo: Image, show: @escaping (String) -> Void) {
        self.config = config
        self.logo = logo
        self.show = show
    }

    public var body: some View {
        VStack(spacing: VeggieSpace.medium) {
            logo
                .resizable()
                .frame(width: logoSide, height: logoSide)
                .clipShape(RoundedRectangle(cornerRadius: logoRadius, style: .continuous))
                .accessibilityHidden(true)
            VStack(spacing: VeggieSpace.small) {
                Text(config.versionLine)
                    .font(style.subheadline)
                    .foregroundStyle(style.textSecondary)
                Text(VeggieText.madeBy)
                    .font(style.footnote)
                    .foregroundStyle(style.textTertiary)
            }
            .contentShape(Rectangle())
            .onLongPressGesture {
                UIPasteboard.general.string = Feedback(config: config).diagnostics
                show(VeggieText.diagnosticsCopied)
            }
            .accessibilityElement(children: .combine)
            .accessibilityHint("長按複製版本資訊")
            .accessibilityIdentifier("veggie-version")
            HStack(spacing: VeggieSpace.large) {
                ForEach(config.links) { link in
                    if let url = link.url {
                        Link(destination: url) {
                            linkIcon(link.kind)
                                .frame(width: style.rowHeight, height: style.rowHeight)
                        }
                        .accessibilityLabel(link.label)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, VeggieSpace.footer)
    }

    @ViewBuilder
    private func linkIcon(_ kind: VeggieLink.Kind) -> some View {
        switch kind {
        case .website:
            Image(systemName: "globe")
                .font(.title2)
                .foregroundStyle(style.textSecondary)
        case .facebook:
            brandIcon("Facebook")
        case .instagram:
            brandIcon("Instagram")
        }
    }

    private func brandIcon(_ name: String) -> some View {
        Image(name, bundle: .module)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: brandIconSide, height: brandIconSide)
            .foregroundStyle(style.textSecondary)
    }
}
