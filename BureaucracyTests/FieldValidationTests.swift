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

class ValidatedField<Type: protocol<Equatable, StringLiteralConvertible>, Internal>: FormField<Type, Internal> {

  init(_ name: String) {
    super.init(name, value: nil, options: nil)
  }

  override func validate(value: Type?) -> NSError? {
    if let aValue = value {
      println("Validating \(aValue)")
      return aValue == "invalid" ? FormValidationError() : nil
    }
    else {
      return nil
    }
  }

}

class FieldValidationTests: XCTestCase {

  let testField = ValidatedField<String, String>("TestField")

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  func test00invalidValue() {
    testField.currentValue = "invalid"

    XCTAssertNotNil(testField.error, "Error should not be nil")
    XCTAssertNil(testField.currentValue, "Current value should remain unchanged")
    XCTAssertNil(testField.previousValue, "Previous value should remain unchanged")
  }

  func test01validValue() {
    testField.currentValue = "valid"

    XCTAssertNil(testField.error, "Error should be nil")
    XCTAssertNil(testField.previousValue, "Previous value should be nil")
    XCTAssertEqual(testField.currentValue!, "valid", "Current value should have been changed")

    testField.currentValue = "also valid"

    XCTAssertNil(testField.error, "Error should be nil")
    XCTAssertEqual(testField.previousValue!, "valid", "Previous value should have been changed")
    XCTAssertEqual(testField.currentValue!, "also valid", "Current value should have been changed")
  }

}
