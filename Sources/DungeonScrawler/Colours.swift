
struct 🎨 {

    static var isEnabled = true

    static var green: String {
        return isEnabled ? "\u{1b}[32m" : ""
    }

    static var bold: String {
        return isEnabled ? "\u{1b}[1m" : ""
    }

    static var italic: String {
        return isEnabled ? "\u{1b}[3m" : ""
    }

    static var reset: String {
        return isEnabled ? "\u{1b}[0m" : ""
    }

}

func cprint(_ items: Any..., terminator: String = "\(🎨.reset)\n") {
    print(items.reduce("", { $0 + String(describing: $1) }), separator: "", terminator: terminator)
}
