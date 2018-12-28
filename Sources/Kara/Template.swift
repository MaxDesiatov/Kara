struct Html { }

struct Page {
    let template: AnyTemplate.Type
    let props: AnyEquatable
}

public struct AnyEquatable: Equatable {
    public let value: Any
    private let equals: (Any) -> Bool
    
    public init<E: Equatable>(_ value: E) {
        self.value = value
        self.equals = { ($0 as? E) == value }
    }
    
    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.equals(rhs.value) || rhs.equals(lhs.value)
    }
}

protocol AnyTemplate {
}

protocol Template: AnyTemplate {
    associatedtype Props: Equatable
    
    static func children(_: Props) -> [String: Page]
    
    static func render(_: Props) -> Html
}

extension Template {
    static func children(_: Props) -> [String: Page] {
        return [:]
    }
    
    static func page(_ props: Props) -> Page {
        return Page(template: self, props: AnyEquatable(props))
    }
}

struct Null: Equatable {}

struct Index: Template {
    static func children(_: Props) -> [String: Page] {
        return Dictionary(uniqueKeysWithValues: (0..<5).map { 
            ("\($0)", Post.page(Null()))
        })
    }
    
    static func render(_: Null) -> Html {
        return Html()
    }
}

struct Post: Template {
    static func render(_: Null) -> Html {
        return Html()
    }
}

