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

  typealias TestField = FormField<String, String>

  let options = ["One", "Two", "Three"]

  var defaultValue: String {
    return options[0]
  }

  var testField: TestField {
    return element as TestField
  }

  override func setUp() {
    super.setUp()
    element = TestField("TestFormElement", value: defaultValue, options: options, cellClass: FormCell.self)
  }

  override func test02serialize() {
    let serialized = testField.serialize()
    XCTAssertTrue(serialized.0 == "TestFormElement" && (serialized.1 as String) == "One", "Serialized element should be a tuple of name and current value, but it is \(serialized)")
  }

  override func test03comparison() {
    super.test03comparison()
    let field1 = TestField("Element1", value: defaultValue, options: options, cellClass: FormCell.self)
    XCTAssertNotEqual(testField, field1, "Elements should not be equal")
  }

  func test05optionCount() {
    XCTAssertEqual(testField.optionCount, options.count, "Option count should equal to size of the options array")
  }

  func test06directOptionAccess() {
    for i in 0..<options.count {
      let referenceOption = options[i]
      let fieldOption = testField.option(i)
      XCTAssertEqual(fieldOption, referenceOption, "Option of field at index \(i) should be equal to \(referenceOption), but it is \(fieldOption)")
    }
  }

  func test07reverseOptionAccess() {
    for x in options {
      let referenceIndex = find(options, x)!
      let optionIndex = testField.optionIndex(x)
      XCTAssertEqual(optionIndex, referenceIndex, "Index of option \(x) should be equal to \(referenceIndex), but it is \(optionIndex)")
    }
  }

  func test08settingValue() {
    XCTAssertEqual(testField.currentValue!, defaultValue, "Initial field value should be equal to \(defaultValue), but it is \(testField.currentValue)")

    testField.currentValue = options[1]
    XCTAssertEqual(testField.currentValue!, options[1], "Updated field value should be equal to \(options[1]), but it is \(testField.currentValue)")
    XCTAssertEqual(testField.previousValue!, defaultValue, "Previous field value should be equal to \(defaultValue), but it is \(testField.previousValue)")
    XCTAssertEqual(testField.internalValue!, testField.currentValue!, "Internal value should be equal to current value")

    testField.internalValue = options[2]
    XCTAssertEqual(testField.currentValue!, options[2], "Updated field value should be equal to \(options[2]), but it is \(testField.currentValue)")
    XCTAssertEqual(testField.previousValue!, options[1], "Previous field value should be equal to \(options[1]), but it is \(testField.previousValue)")
    XCTAssertEqual(testField.internalValue!, testField.currentValue!, "Internal value should be equal to current value")
  }

  func test10fieldUpdates() { // TODO: Move to section tests
    class TestSection: FormSection {
      var updated = false
      var testField: FormElement?
      override func didUpdate(#field: FormElement?) {
        XCTAssertEqual(field!, testField!)
        updated = true
      }
    }

    let section = TestSection("TestSection")
    section.testField = testField
    section.append(testField)
    testField.currentValue = options[2]
    XCTAssertTrue(section.updated, "Field update should've triggered didUpdate method in section")
  }

}
