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
      delegate?.didUpdateForm()
    }
  }

  var sections: [FormSection] = []

  public init() {}
  public func numberOfSections() -> Int {
    return sections.count
  }
  

  public func numberOfFieldsInSection(section: Int) -> Int {
    return sections[section].numberOfFields()
  }

  public func addSection(title: String) -> FormSection {
    var section = FormSection()
    section.title = title

    sections += [section]
    delegate?.didUpdateForm()
    return section
  }

}

public protocol FormDelegate: class {
  func didUpdateForm()
}
