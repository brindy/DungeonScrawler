
struct 🎨 {

    static var isEnabled = true

    static var red: String {
        return isEnabled ? "\u{1b}[31m" : ""
    }
    
    static var green: String {
        return isEnabled ? "\u{1b}[32m" : ""
    }

    static var yellow: String {
        return isEnabled ? "\u{1b}[33m" : ""
    }

    static var blue: String {
        return isEnabled ? "\u{1b}[34m" : ""
    }

    static var purple: String {
        return isEnabled ? "\u{1b}[35m" : ""
    }

    static var cyan: String {
        return isEnabled ? "\u{1b}[36m" : ""
    }

    static var grey: String {
        return isEnabled ? "\u{1b}[37m" : ""
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
