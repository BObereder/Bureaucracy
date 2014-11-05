//
//  Form.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation
import SwiftHelpers

public class Form: SequenceType {

  public init() {}

  public weak var delegate: FormDelegate?

  public var title: String? {
    didSet {
      delegate?.didUpdateForm(self)
    }
  }

  public var sections: [FormSection] = []

  public func numberOfSections() -> Int {
    return sections.count
  }

  public func numberOfFieldsInSection(section: Int) -> Int {
    if sections.count > section {
      return sections[section].numberOfFields()
    }
    return 0
  }

  public func item(#indexPath: NSIndexPath) -> FormElement {
    return sections[indexPath.section].items[indexPath.item]
  }

  public func addSection(name: String) -> FormSection {
    var section = FormSection(form: self, name: name)
    sections += [section]
    delegate?.didUpdateForm(self)
    return section
  }
  
  public func serialize() -> [[String: Any?]] {
    return sections.map { $0.serialize() }
  }

  // MARK: - SequenceType

  public func generate() -> GenericGenerator<FormSection> {
    return GenericGenerator(items: sections)
  }

}

public protocol FormDelegate: class {
  func didUpdateForm(form: Form)
}
