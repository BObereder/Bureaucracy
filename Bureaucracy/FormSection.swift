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

  var fields: [FormField] = []

  public init() { }

  public func numberOfFields() -> Int {
    return fields.count
  }

}
