//
//  FieldValidation.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 18.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Bureaucracy
import UIKit
import XCTest

class ValidatedField<Type, Internal>: FormField<String, String> {

  init(_ name: String) {
    super.init(name, value: nil, options: nil)
  }

  override func validate(value: String?) -> NSError? {
    if let aValue = value {
      return aValue == "valid" ? nil : FormValidationError()
    }
    else {
      return nil
    }
  }

}

class FieldValidation: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  private func test00validation() {
    let field = ValidatedField<String, String>("TestField")
    field.currentValue = "invalid"

    XCTAssertNotNil(field.error, "Error should not be nil")
  }

}
