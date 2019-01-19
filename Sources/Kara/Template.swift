import Html

public struct Page {
  let template: AnyTemplate.Type
  let props: AnyEquatable
}

public struct AnyEquatable: Equatable {
  public let value: Any
  private let equals: (Any) -> Bool

  public init<E: Equatable>(_ value: E) {
    self.value = value
    equals = { ($0 as? E) == value }
  }

  public static func ==(lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
    return lhs.equals(rhs.value) || rhs.equals(lhs.value)
  }
}

public protocol AnyTemplate {}

public protocol Template: AnyTemplate {
  associatedtype Props: Equatable

  static func children(_: Props) -> [String: Page]

  static func render(_: Props) -> Node
}

extension Template {
  public static func children(_: Props) -> [String: Page] {
    return [:]
  }

  public static func page(_ props: Props) -> Page {
    return Page(template: self, props: AnyEquatable(props))
  }
}

public struct Null: Equatable {}

extension Template where Props == Null {
  public static func page() -> Page {
    return page(Null())
  }
}

struct Index: Template {
  static func children(_: Props) -> [String: Page] {
    return Dictionary(uniqueKeysWithValues: (0..<5).map {
      ("\($0)", Post.page())
    })
  }

  static func render(_: Null) -> Node {
    return html([body([Node.raw("<p></p>")])])
  }
}

struct Post: Template {
  static func render(_: Null) -> Node {
    return html([])
  }
}
