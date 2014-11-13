//
//  FormFieldTests.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 12.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Bureaucracy
import UIKit
import XCTest

class FormFieldTests: FormElementTests {

  typealias TestField = FormField<String, String, String>

  let options = ["One", "Two", "Three"]

  var defaultValue: String {
    return options[0]
  }

  var field: TestField {
    return element as TestField
  }

  override func setUp() {
    super.setUp()
    element = TestField("TestFormElement", value: defaultValue, options: options, cellClass: FormCell.self)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  override func test02serialize() {
    let serialized = field.serialize()
    XCTAssertTrue(serialized.0 == "TestFormElement" && (serialized.1 as String) == "One", "Serialized element should be a tuple of name and current value, but it is \(serialized)")
  }

  override func test03comparison() {
    super.test03comparison()
    let field1 = TestField("Element1", value: defaultValue, options: options, cellClass: FormCell.self)
    XCTAssertNotEqual(field, field1, "Elements should not be equal")
  }

  func test05optionCount() {
    XCTAssertEqual(field.optionCount, options.count, "Option count should equal to size of the options array")
  }

  func test06directOptionAccess() {
    for i in 0..<options.count {
      let referenceOption = options[i]
      let fieldOption = field.option(i)
      XCTAssertEqual(fieldOption, referenceOption, "Option of field at index \(i) should be equal to \(referenceOption), but it is \(fieldOption)")
    }
  }

  func test07reverseOptionAccess() {
    for x in options {
      let referenceIndex = find(options, x)!
      let optionIndex = field.optionIndex(x)
      XCTAssertEqual(optionIndex, referenceIndex, "Index of option \(x) should be equal to \(referenceIndex), but it is \(optionIndex)")
    }
  }

  func test08settingValue() {
    XCTAssertEqual(field.currentValue!, defaultValue, "Initial field value should be equal to \(defaultValue), but it is \(field.currentValue)")

    field.currentValue = options[2]
    XCTAssertEqual(field.currentValue!, options[2], "Updated field value should be equal to \(options[2]), but it is \(field.currentValue)")
    XCTAssertEqual(field.previousValue!, defaultValue, "Previous field value should be equal to \(field.previousValue), but it is \(defaultValue)")
  }

}
