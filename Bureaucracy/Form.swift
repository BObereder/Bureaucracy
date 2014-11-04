//
//  Form.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class Form {

  public weak var delegate: FormDelegate?

  public var title: String? {
    didSet {
      delegate?.didUpdateForm(self)
    }
  }

  public var sections: [FormSection] = []

  public init() {}
  public func numberOfSections() -> Int {
    return sections.count
  }

  public func numberOfFieldsInSection(section: Int) -> Int {
    return sections[section].numberOfFields()
  }

  public func addSection(name: String) -> FormSection {
    var section = FormSection(form: self, name: name)
    sections += [section]
    delegate?.didUpdateForm(self)
    return section
  }
  
  public func serialize() -> [[[String: Any?]]] {
    return sections.map { $0.values() }
  }

}

public protocol FormDelegate: class {
  func didUpdateForm(form: Form)
}
