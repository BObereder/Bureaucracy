//
//  FormSection.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Foundation

public class FormSection {

  public var title: String?

  var elements: [FormElement] = []

  public init() { }

  public func numberOfFields() -> Int {
    return elements.count
  }

}
