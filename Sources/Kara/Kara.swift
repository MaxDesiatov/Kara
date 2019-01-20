//
//  File.swift
//  Kara
//
//  Created by Max Desiatov on 20/01/2019.
//

import Foundation
import Html

public func kara(_ page: Page, destination: String) throws {
  let manager = FileManager()

  let data = render(page.template.render(props: page.props)).data(using: .utf8)

  manager.createFile(atPath: destination, contents: data)
}
