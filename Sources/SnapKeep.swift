import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!
    private let titleLabel = NSTextField(labelWithString: "SnapKeep")
    private let subtitle = NSTextField(wrappingLabelWithString: "")
    private let detail = NSTextField(wrappingLabelWithString: "")
    private let status = NSTextField(wrappingLabelWithString: "")
    private let installButton = NSButton()
    private let uninstallButton = NSButton()
    private let folderButton = NSButton()
    private let languageButton = NSButton()
    private let spinner = NSProgressIndicator()
    private let preferences = UserDefaults.standard
    private var chinese = false
    private var busy = false

    private func text(_ zh: String, _ en: String) -> String { chinese ? zh : en }

    func applicationDidFinishLaunching(_ notification: Notification) {
        chinese = (preferences.string(forKey: "language") ?? Locale.preferredLanguages.first ?? "en").hasPrefix("zh")
        makeMenu()
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 560, height: 540), styleMask: [.titled, .closable, .miniaturizable], backing: .buffered, defer: false)
        window.title = "SnapKeep"
        window.center()
        window.isReleasedWhenClosed = false
        let content = window.contentView!
        content.wantsLayer = true
        content.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor

        let icon = NSImageView(frame: NSRect(x: 234, y: 400, width: 92, height: 92))
        icon.image = NSImage(named: NSImage.applicationIconName)
        icon.imageScaling = .scaleProportionallyUpOrDown
        content.addSubview(icon)
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.alignment = .center
        titleLabel.frame = NSRect(x: 40, y: 350, width: 480, height: 42)
        content.addSubview(titleLabel)
        subtitle.font = .systemFont(ofSize: 19, weight: .medium)
        subtitle.alignment = .center
        subtitle.frame = NSRect(x: 32, y: 301, width: 496, height: 42)
        content.addSubview(subtitle)
        detail.font = .systemFont(ofSize: 14)
        detail.textColor = .secondaryLabelColor
        detail.alignment = .center
        detail.frame = NSRect(x: 48, y: 230, width: 464, height: 64)
        content.addSubview(detail)

        installButton.frame = NSRect(x: 100, y: 172, width: 360, height: 42)
        installButton.bezelStyle = .rounded
        installButton.controlSize = .large
        installButton.bezelColor = .systemBlue
        installButton.contentTintColor = .white
        installButton.keyEquivalent = "\r"
        installButton.target = self
        installButton.action = #selector(install)
        content.addSubview(installButton)

        uninstallButton.frame = NSRect(x: 94, y: 117, width: 180, height: 32)
        uninstallButton.bezelStyle = .rounded
        uninstallButton.target = self
        uninstallButton.action = #selector(uninstall)
        content.addSubview(uninstallButton)
        folderButton.frame = NSRect(x: 280, y: 117, width: 186, height: 32)
        folderButton.bezelStyle = .rounded
        folderButton.target = self
        folderButton.action = #selector(openFolder)
        content.addSubview(folderButton)

        languageButton.frame = NSRect(x: 450, y: 488, width: 82, height: 28)
        languageButton.bezelStyle = .rounded
        languageButton.target = self
        languageButton.action = #selector(toggleLanguage)
        content.addSubview(languageButton)
        spinner.style = .spinning
        spinner.frame = NSRect(x: 264, y: 83, width: 24, height: 24)
        spinner.isDisplayedWhenStopped = false
        content.addSubview(spinner)
        status.frame = NSRect(x: 38, y: 18, width: 484, height: 58)
        status.font = .systemFont(ofSize: 12)
        status.alignment = .center
        status.textColor = .secondaryLabelColor
        content.addSubview(status)
        refresh()
        if let option = CommandLine.arguments.firstIndex(of: "--render-previews"), CommandLine.arguments.count > option + 1 {
            let directory = URL(fileURLWithPath: CommandLine.arguments[option + 1], isDirectory: true)
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                for language in [false, true] {
                    chinese = language
                    refresh()
                    content.layoutSubtreeIfNeeded()
                    if let bitmap = content.bitmapImageRepForCachingDisplay(in: content.bounds) {
                        content.cacheDisplay(in: content.bounds, to: bitmap)
                        if let data = bitmap.representation(using: .png, properties: [:]) {
                            try data.write(to: directory.appendingPathComponent(language ? "setup-zh.png" : "setup-en.png"))
                        }
                    }
                }
                NSApp.terminate(nil)
                return
            } catch { fputs("Preview error: \(error)\n", stderr) }
        }
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func makeMenu() {
        let menu = NSMenu()
        let root = NSMenuItem()
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: "Quit SnapKeep", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        root.submenu = appMenu
        menu.addItem(root)
        NSApp.mainMenu = menu
    }

    private func refresh() {
        subtitle.stringValue = text("截一次，保存和复制一起完成。", "One screenshot. Saved and copied.")
        detail.stringValue = text("照常使用 ⌘⇧3 / ⌘⇧4 / ⌘⇧5\n自动存入桌面“截屏”，并显示复制成功通知。", "Use ⌘⇧3 / ⌘⇧4 / ⌘⇧5 as usual.\nSaved to Desktop/截屏, with a copy confirmation.")
        installButton.title = text("启用 / 更新截屏即贴", "Enable / Update SnapKeep")
        uninstallButton.title = text("卸载并恢复设置", "Uninstall & restore")
        folderButton.title = text("打开截屏文件夹", "Open screenshots")
        languageButton.title = chinese ? "English" : "中文"
        status.stringValue = preferences.bool(forKey: "installed")
            ? text("已安装 · 可关闭本窗口，截屏复制持续生效。", "Installed · You can quit this app; copying stays enabled.")
            : text("首次启用请允许控制 System Events。\n完全本机运行，无需账户或管理员密码。", "Allow System Events control when first enabling.\nRuns locally. No account or administrator password.")
    }

    @objc private func toggleLanguage() {
        chinese.toggle()
        preferences.set(chinese ? "zh" : "en", forKey: "language")
        refresh()
    }
    @objc private func install() { runAction("install") }
    @objc private func uninstall() {
        let alert = NSAlert()
        alert.messageText = text("卸载 SnapKeep？", "Uninstall SnapKeep?")
        alert.informativeText = text("保留所有截屏；恢复安装前的保存设置。", "Keeps all screenshots and restores your pre-install save settings.")
        alert.addButton(withTitle: text("卸载", "Uninstall"))
        alert.addButton(withTitle: text("取消", "Cancel"))
        if alert.runModal() == .alertFirstButtonReturn { runAction("uninstall") }
    }
    @objc private func openFolder() {
        NSWorkspace.shared.open(FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/截屏"))
    }

    private func runAction(_ action: String) {
        guard !busy, let resources = Bundle.main.resourceURL else { return }
        busy = true
        [installButton, uninstallButton, languageButton].forEach { $0.isEnabled = false }
        spinner.startAnimation(nil)
        status.stringValue = text("正在配置…系统授权窗口出现时请选择允许。", "Configuring… Allow the macOS automation prompt if shown.")
        let language = chinese ? "zh" : "en"
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            let pipe = Pipe()
            process.executableURL = URL(fileURLWithPath: "/bin/zsh")
            process.arguments = [resources.appendingPathComponent("Scripts/manage.zsh").path, action, language]
            process.standardOutput = pipe
            process.standardError = pipe
            var output = ""
            var success = false
            do {
                try process.run()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                process.waitUntilExit()
                output = String(data: data, encoding: .utf8) ?? ""
                success = process.terminationStatus == 0
            } catch { output = error.localizedDescription }
            DispatchQueue.main.async {
                self.busy = false
                [self.installButton, self.uninstallButton, self.languageButton].forEach { $0.isEnabled = true }
                self.spinner.stopAnimation(nil)
                if success {
                    self.preferences.set(action == "install", forKey: "installed")
                    self.refresh()
                    self.status.stringValue = action == "install"
                        ? self.text("已启用 · 截屏后自动保存 + 复制，可退出本应用。", "Enabled · Screenshots save + copy. You can quit this app.")
                        : self.text("已卸载 · 所有截屏均已保留。", "Uninstalled · All screenshots were kept.")
                } else {
                    self.status.stringValue = self.text("配置未完成，请查看错误信息。", "Setup incomplete. See the error details.")
                    let alert = NSAlert()
                    alert.messageText = self.text("配置未完成", "Setup incomplete")
                    alert.informativeText = self.text("若曾拒绝授权，请在系统设置 → 隐私与安全性 → 自动化中允许 SnapKeep 控制 System Events。\n\n", "If you denied access, allow SnapKeep to control System Events in System Settings → Privacy & Security → Automation.\n\n") + output
                    alert.runModal()
                }
            }
        }
    }
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        busy ? .terminateCancel : .terminateNow
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { !busy }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        window.makeKeyAndOrderFront(nil)
        return true
    }
}

let application = NSApplication.shared
let delegate = AppDelegate()
application.delegate = delegate
application.setActivationPolicy(.regular)
application.run()
