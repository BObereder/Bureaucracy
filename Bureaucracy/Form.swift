//
//  Form.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation
import SwiftHelpers

public class Form: CollectionType {

  public init() {}

  public weak var delegate: FormDelegate?
  public weak var dataSource: FormDataSource?

  public var title: String? {
    didSet {
      delegate?.didUpdateForm(self, section: nil, field: nil)
    }
  }

  // MARK: CollectionType

  public subscript(position: Int) -> FormSection {
    return sections[position]
  }

  public var startIndex: Int {
    return 0
  }

  public var endIndex: Int {
    return sections.count
  }

  // MARK: -

  public var sections: [FormSection] = []

  public var numberOfSections: Int {
    return sections.count
  }

  public func numberOfFieldsInSection(section: Int) -> Int {
    return sections[section].count
  }

  public func item(#indexPath: NSIndexPath) -> FormElement {
    return sections[indexPath.section][indexPath.item]
  }

  public func addSection(name: String) -> FormSection {
    return addSection(FormSection(name))
  }

  public func addSection(section: FormSection) -> FormSection {
    section.form = self
    sections += [section]
    delegate?.didUpdateForm(self, section: section, field: nil)
    return section
  }

  public func didUpdate(#section: FormSection?, field: FormElement?) {
    delegate?.didUpdateForm(self, section: section, field: nil)
  }

  public func serialize() -> [[String: Any?]] {
    return sections.map { $0.serialize() }
  }

  public func reloadInterface() {
    dataSource?.reloadTable()
  }

  // MARK: - SequenceType

  public func generate() -> GenericGenerator<FormSection> {
    return GenericGenerator(items: sections)
  }

}

public protocol FormDelegate: class {
  func didUpdateForm(form: Form, section: FormSection?, field: FormElement?)
}
