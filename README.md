# VeggieKit

蔬菜家族每個 iOS app 設定頁都長一樣的那幾區：一般、資料、購買、支援、關於，和最下面的頁尾。以前茄記、豆鍵、蒜日子各抄一份，改一個網址要改三個地方，現在收成這一包。

規格照《蔬菜家族 App 共用基本元素規格》（2026-11-14）。iOS 17 起，Swift 5.10，不連網，沒有用到別人的套件。

## 裡面有什麼

| 檔案 | 內容 |
| --- | --- |
| `VeggieConfig.swift` | 每個 app 一份的設定（名稱、一句話介紹、Apple ID、回饋信箱、隱私權政策網址）、全系列共用的官網／臉書／IG 連結、蔬菜家族 app 清單、共用文案、觸覺回饋開關 |
| `VeggieStyle.swift` | 顏色和字。套件不認得各 app 的色票，由 app 傳進來 |
| `Appearance.swift` | 外觀：跟隨系統／淺色／深色 |
| `Feedback.swift` | 意見回饋的信（主旨、版本資訊）和系統寫信畫面 |
| `VeggieRow.swift` | 設定頁的一列、開關列 |
| `VeggieFooter.swift` | 頁尾：app 圖示、版本、Made by DOMYWEB、三個連結，長按版本號複製版本資訊 |
| `VeggiePages.swift` | 開源授權頁、蔬菜家族的其他 app 頁 |

## 接進 app

Xcode → File → Add Package Dependencies，貼 `https://github.com/domyweb666/VeggieKit`，版本選 Up to Next Major。

```swift
import VeggieKit

extension VeggieConfig {
    static let app = VeggieConfig(
        name: "人蔘修煉",
        slug: "rencan",
        tagline: "量完體組成，看你練到哪個境界",
        appStoreID: nil,                      // 上架拿到 Apple ID 再填，評分那列才會出現
        supportEmail: "charlie@domyweb.org",
        privacyURL: URL(string: "https://domyweb.org/rencan/privacy")
    )
}

// 設定頁外面包一次，裡面的共用元件就用 app 自己的顏色和字
SettingsView()
    .veggieStyle(VeggieStyle(textPrimary: ..., accent: ..., body: ..., ...))
```

觸覺回饋：app 震之前先看 `VeggieHaptics.isEnabled`。外觀：app 一打開就呼叫一次 `Appearance.stored.apply()`。

## 改東西的規矩

- 新 app 上架後，到 `VeggieApp.family` 補它的 Apple ID，其他 app 下一版的「蔬菜家族的其他 app」才看得到它。
- 官網、臉書、IG 網址改 `VeggieLink.domyweb` 一處。
- 改完打新的版本 tag（1.0.1、1.1.0），各 app 再各自升級。不要移動已經打過的 tag，已經送審的 app 是照 tag 抓的。
