import Html

public struct Rendered {
  public let node: Node
  public let children: [String: Page]

  public init(_ node: Node, children: [String: Page] = [:]) {
    self.node = node
    self.children = children
  }
}

public protocol AnyTemplate {
  static func render(props: AnyEquatable) -> Rendered
}

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

public protocol Template: AnyTemplate {
  associatedtype Props: Equatable

  static func render(props: Props) -> Rendered
}

extension Template {
  static func render(props: AnyEquatable) -> Rendered {
    guard let props = props.value as? Props else {
      fatalError("incorrect type of `props` passed to `AnyTemplate.render`")
    }

    return render(props: props)
  }
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
