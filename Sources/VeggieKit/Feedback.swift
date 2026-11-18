import MessageUI
import SwiftUI
import UIKit

/// 意見回饋與版本資訊：主旨「[app 名] 意見回饋」，內文最下面帶版本資訊（使用者看得到、可以刪）。
/// 版本資訊只有 app 版本、iOS 版本、機型、語言，不帶任何使用者自己的資料（各 app 的安全標準都要求這樣）
@MainActor
public struct Feedback {
    public let config: VeggieConfig

    public init(config: VeggieConfig) {
        self.config = config
    }

    public var subject: String {
        "[\(config.name)] 意見回饋"
    }

    public var body: String {
        "（請在這裡寫下你的想法）\n\n\n\n——\n" + diagnostics
    }

    /// 頁尾長按版本號複製的也是這段
    public var diagnostics: String {
        [
            "App：\(config.versionLine)",
            "iOS：\(UIDevice.current.systemVersion)",
            "機型：\(Self.machine)",
            "語言：\(Locale.preferredLanguages.first ?? "")"
        ].joined(separator: "\n")
    }

    /// 機型代號，例如 iPhone17,1（不另外對照成 iPhone 16 Pro 這種名字，新機一出就要改表）
    private static var machine: String {
        var info = utsname()
        uname(&info)
        return withUnsafePointer(to: &info.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) { String(cString: $0) }
        }
    }

    public static var canUseMailSheet: Bool {
        MFMailComposeViewController.canSendMail()
    }

    /// 手機沒設郵件帳號時改用 mailto（交給使用者裝的其他寄信 app）
    public func mailtoURL(to address: String) -> URL? {
        var parts = URLComponents()
        parts.scheme = "mailto"
        parts.path = address
        parts.queryItems = [URLQueryItem(name: "subject", value: subject), URLQueryItem(name: "body", value: body)]
        return parts.url
    }
}

/// 系統寫信畫面。寄不寄由使用者自己按，app 不會自己寄
public struct FeedbackMailView: UIViewControllerRepresentable {
    let recipient: String
    let feedback: Feedback
    let onDone: () -> Void

    public init(recipient: String, feedback: Feedback, onDone: @escaping () -> Void) {
        self.recipient = recipient
        self.feedback = feedback
        self.onDone = onDone
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(onDone: onDone)
    }

    public func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setToRecipients([recipient])
        mail.setSubject(feedback.subject)
        mail.setMessageBody(feedback.body, isHTML: false)
        return mail
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    public final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let onDone: () -> Void

        init(onDone: @escaping () -> Void) {
            self.onDone = onDone
        }

        public func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            onDone()
        }
    }
}
