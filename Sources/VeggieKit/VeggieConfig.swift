import Foundation

// 蔬菜家族共用元素（規格：《蔬菜家族 App 共用基本元素規格》2026-11-14）。
// 從豆鍵、蒜日子各自的 App/Veggie/ 合併出來（2026-11-19）。每個 app 只要給一份 VeggieConfig、一份 VeggieStyle。

/// 每個 app 一份的設定。值是 nil 的那一列，設定頁整列隱藏。
public struct VeggieConfig {
    public let name: String
    /// 跟 VeggieApp.family 裡的 slug 對得上，「其他 app」清單才會把自己排除
    public let slug: String
    /// 一句話介紹，分享給朋友時跟著連結一起送出
    public let tagline: String
    /// App Store Connect → App 資訊 → Apple ID（一串數字）。填了才有評分、分享連結
    public let appStoreID: String?
    /// 意見回饋的收件信箱（全系列共用一個）。填了才出現意見回饋
    public let supportEmail: String?
    /// 隱私權政策網頁（要跟 App Store Connect 填的同一頁）
    public let privacyURL: URL?
    /// 設定頁最下面的連結（網站、FB、IG），照順序排
    public let links: [VeggieLink]

    public init(
        name: String, slug: String, tagline: String, appStoreID: String?,
        supportEmail: String?, privacyURL: URL?, links: [VeggieLink] = VeggieLink.domyweb
    ) {
        self.name = name
        self.slug = slug
        self.tagline = tagline
        self.appStoreID = appStoreID
        self.supportEmail = supportEmail
        self.privacyURL = privacyURL
        self.links = links
    }

    public var appStoreURL: URL? {
        appStoreID.flatMap { URL(string: "https://apps.apple.com/app/id\($0)") }
    }

    public var writeReviewURL: URL? {
        appStoreID.flatMap { URL(string: "https://apps.apple.com/app/id\($0)?action=write-review") }
    }

    /// 分享給朋友時送出的字：一句話介紹＋下載連結。還沒有 Apple ID 時改寫怎麼搜尋。
    public var shareText: String {
        let intro = name + "：" + tagline + "。"
        guard let url = appStoreURL else {
            return intro + "App Store 搜尋「" + name + "」就找得到。"
        }
        return intro + url.absoluteString
    }

    /// 「人蔘修煉 1.0（36）」：版本號，括號裡是第幾次建置
    public var versionLine: String {
        let info = Bundle.main.infoDictionary
        let version = info?["CFBundleShortVersionString"] as? String ?? ""
        let build = info?["CFBundleVersion"] as? String ?? ""
        return "\(name) \(version)（\(build)）"
    }
}

/// 設定頁最下面的一顆連結鈕
public struct VeggieLink: Identifiable {
    public enum Kind {
        case website
        case facebook
        case instagram
    }

    public let kind: Kind
    public let address: String

    public init(kind: Kind, address: String) {
        self.kind = kind
        self.address = address
    }

    public var id: String { address }

    public var url: URL? { URL(string: address) }

    /// 給語音朗讀的名稱
    public var label: String {
        switch kind {
        case .website: return "網站"
        case .facebook: return "Facebook"
        case .instagram: return "Instagram"
        }
    }

    /// 全系列共用的三個：官網、臉書粉專、IG。網址改這裡一處，每個 app 下一版跟著換
    public static let domyweb: [VeggieLink] = [
        VeggieLink(kind: .website, address: "https://domyweb.org/"),
        VeggieLink(kind: .facebook, address: "https://www.facebook.com/profile.php?id=61556891560581"),
        VeggieLink(kind: .instagram, address: "https://www.instagram.com/domyweb_fc/")
    ]
}

/// 蔬菜家族的其他 app。全系列不連網，用這份內建清單（規格原本是讀網路上的 apps.json）。
/// 沒有 App Store ID 也沒有網頁的不顯示；一個都沒有時，設定頁整列隱藏。新 app 上架後在這裡補 ID
public struct VeggieApp: Identifiable {
    public let slug: String
    public let name: String
    public let tagline: String
    public let appStoreID: String?
    public let webURL: URL?

    public var id: String { slug }

    public var link: URL? {
        if let appStoreID {
            return URL(string: "https://apps.apple.com/app/id\(appStoreID)")
        }
        return webURL
    }

    public static let family: [VeggieApp] = [
        VeggieApp(slug: "qieji", name: "茄記", tagline: "想到就記", appStoreID: "6829151838", webURL: nil),
        VeggieApp(slug: "doujian", name: "豆鍵", tagline: "字大鍵緊，少按錯的注音鍵盤", appStoreID: "6829152938", webURL: nil),
        VeggieApp(slug: "suanrizi", name: "蒜日子", tagline: "手機上看得清楚的月曆", appStoreID: nil, webURL: nil),
        VeggieApp(slug: "rencan", name: "人蔘修煉", tagline: "量完體組成，看你練到哪個境界", appStoreID: nil, webURL: nil)
    ]

    /// 設定頁要列出來的：有連結、而且不是自己
    public static func others(excluding slug: String) -> [VeggieApp] {
        family.filter { $0.slug != slug && $0.link != nil }
    }
}

/// 共用文案：全系列同一個東西叫同一個名字
public enum VeggieText {
    public static let general = "一般"
    public static let data = "資料"
    public static let purchase = "購買"
    public static let support = "支援"
    public static let about = "關於"
    public static let appearance = "外觀"
    public static let appearanceSystem = "跟隨系統"
    public static let appearanceLight = "淺色"
    public static let appearanceDark = "深色"
    public static let notifications = "通知"
    public static let haptics = "觸覺回饋"
    public static let exportData = "匯出資料"
    public static let importData = "匯入資料"
    public static let eraseAll = "清除所有資料"
    public static let restore = "恢復購買"
    public static let restored = "已恢復你的購買"
    public static let restoreNothing = "沒有找到購買紀錄"
    public static let restoreFailed = "出了點問題，請再試一次"
    public static let feedback = "意見回饋"
    public static let rate = "在 App Store 給我們評分"
    public static let share = "分享給朋友"
    public static let family = "蔬菜家族的其他 app"
    public static let privacy = "隱私權政策"
    public static let licenses = "開源授權"
    public static let diagnosticsCopied = "已複製版本資訊"
    public static let madeBy = "Made by DOMYWEB"
    public static let get = "取得"
}

/// 觸覺回饋開關（規格：觸覺回饋可以在設定頁關掉）。預設開；存在 UserDefaults，各 app 震之前先問這裡
public enum VeggieHaptics {
    public static let storageKey = "haptics"

    public static var isEnabled: Bool {
        UserDefaults.standard.object(forKey: storageKey) as? Bool ?? true
    }
}
