import SwiftUI

/// 開源授權的一項：名稱、授權名稱、app 資源裡那份全文的檔名（例如 OFL-LXGWWenKaiTC.txt）
public struct VeggieLicense: Identifiable {
    public let name: String
    public let license: String
    public let file: String

    public init(name: String, license: String, file: String) {
        self.name = name
        self.license = license
        self.file = file
    }

    public var id: String { file }

    /// 全文直接讀 app 裡的原始授權檔，不另外抄一份。讀不到就回 nil，由畫面說讀不到
    var fullText: String? {
        let parts = file.split(separator: ".", maxSplits: 1).map(String.init)
        guard parts.count == 2,
            let url = Bundle.main.url(forResource: parts[0], withExtension: parts[1])
        else { return nil }
        return try? String(contentsOf: url, encoding: .utf8)
    }
}

/// 開源授權頁：每個用到的套件、字型的名稱，點進去看全文。
/// 不自己包 NavigationStack，由 app 決定是推進去還是彈出來
public struct VeggieLicensesView: View {
    @Environment(\.veggieStyle) private var style
    let items: [VeggieLicense]

    public init(items: [VeggieLicense]) {
        self.items = items
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    if index > 0 {
                        Divider()
                    }
                    NavigationLink {
                        VeggieLicenseTextView(item: item)
                    } label: {
                        VeggieRow(icon: "doc.text", title: item.name, accessory: .push)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, VeggieSpace.large)
            .background(style.surface, in: RoundedRectangle(cornerRadius: VeggieSpace.medium))
            .padding(VeggieSpace.large)
        }
        .background(style.canvas)
        .navigationTitle(VeggieText.licenses)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 一份授權的全文
private struct VeggieLicenseTextView: View {
    @Environment(\.veggieStyle) private var style
    let item: VeggieLicense

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: VeggieSpace.medium) {
                Text(item.license)
                    .font(style.headline)
                    .foregroundStyle(style.textPrimary)
                // 讀不到全文時大聲說，不留一片空白讓人以為就是這樣
                Text(item.fullText ?? "讀不到授權全文（\(item.file)）")
                    .font(.footnote.monospaced())
                    .foregroundStyle(style.textSecondary)
                    .textSelection(.enabled)
            }
            .padding(VeggieSpace.large)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(style.canvas)
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 蔬菜家族的其他 app：內建清單，點了開 App Store（或網頁）
public struct VeggieFamilyView: View {
    @Environment(\.veggieStyle) private var style
    let apps: [VeggieApp]

    public init(config: VeggieConfig) {
        apps = VeggieApp.others(excluding: config.slug)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(apps.enumerated()), id: \.element.id) { index, app in
                    if index > 0 {
                        Divider()
                    }
                    if let link = app.link {
                        Link(destination: link) {
                            row(app)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, VeggieSpace.large)
            .background(style.surface, in: RoundedRectangle(cornerRadius: VeggieSpace.medium))
            .padding(VeggieSpace.large)
        }
        .background(style.canvas)
        .navigationTitle(VeggieText.family)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ app: VeggieApp) -> some View {
        HStack(spacing: VeggieSpace.medium) {
            VStack(alignment: .leading, spacing: VeggieSpace.small / 2) {
                Text(app.name)
                    .font(style.headline)
                    .foregroundStyle(style.textPrimary)
                Text(app.tagline)
                    .font(style.subheadline)
                    .foregroundStyle(style.textSecondary)
            }
            Spacer()
            Text(VeggieText.get)
                .font(style.body)
                .foregroundStyle(style.accent)
        }
        .frame(minHeight: style.rowHeight)
        .padding(.vertical, VeggieSpace.small)
        .contentShape(Rectangle())
    }
}
