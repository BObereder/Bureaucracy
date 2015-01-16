//
//  SwitchFormFieldTests.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 16.01.15.
//  Copyright (c) 2015 Alexander Kolov. All rights reserved.
//

import Bureaucracy
import UIKit
import XCTest

class SwitchFormFieldTests: FormElementTests {

  typealias TestField = SwitchFormField<Bool, Bool>

  let options = [true, false]

  var defaultValue: Bool {
    return options[0]
  }

  var testField: TestField {
    return element as TestField
  }

  override func setUp() {
    super.setUp()
    element = TestField("TestSwitchFormField", value: options[0], options: options)
  }

  override func test01serialize() {
    let serialized = testField.serialize()
    XCTAssertTrue(serialized.0 == "TestSwitchFormField" && (serialized.1 as Bool) == true, "Serialized element should be a tuple of name and current value, but it is \(serialized)")
  }
  
  override func test02comparison() {
    super.test02comparison()
    let field1 = TestField("Element1", value: defaultValue, options: options)
    XCTAssertNotEqual(testField, field1, "Elements should not be equal")
  }
}