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
  public weak var dataSource: FormDataSource?

  public var title: String? {
    didSet {
      delegate?.didUpdateForm(self, section: nil, item: nil)
    }
  }

  public var sections: [FormSection] = []

  public func numberOfSections() -> Int {
    return sections.count
  }

  public func numberOfFieldsInSection(section: Int) -> Int {
    return sections[section].count
  }

  public func item(#indexPath: NSIndexPath) -> FormElement {
    return sections[indexPath.section].item(indexPath.item)
  }

  public func addSection(name: String) -> FormSection {
    return addSection(FormSection(name))
  }

  public func addSection(section: FormSection) -> FormSection {
    section.form = self
    sections += [section]
    delegate?.didUpdateForm(self, section: section, item: nil)
    return section
  }

  public func didUpdate(#section: FormSection?, item: FormElement?) {
    delegate?.didUpdateForm(self, section: section, item: nil)
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
  func didUpdateForm(form: Form, section: FormSection?, item: FormElement?)
}
