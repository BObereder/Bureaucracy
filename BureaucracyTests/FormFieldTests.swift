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
    element = TestField("TestFormElement", value: defaultValue, options: options)
  }

  override func test01serialize() {
    let serialized = testField.serialize()
    XCTAssertTrue(serialized.0 == "TestFormElement" && (serialized.1 as String) == "One", "Serialized element should be a tuple of name and current value, but it is \(serialized)")
  }

  override func test02comparison() {
    super.test02comparison()
    let field1 = TestField("Element1", value: defaultValue, options: options)
    XCTAssertNotEqual(testField, field1, "Elements should not be equal")
  }

  func test04optionCount() {
    XCTAssertEqual(testField.optionCount, options.count, "Option count should equal to size of the options array")
  }

  func test05directOptionAccess() {
    for i in 0..<options.count {
      let referenceOption = options[i]
      let fieldOption = testField.option(i)
      XCTAssertEqual(fieldOption, referenceOption, "Option of field at index \(i) should be equal to \(referenceOption), but it is \(fieldOption)")
    }
  }

  func test06reverseOptionAccess() {
    for x in options {
      let referenceIndex = find(options, x)!
      let optionIndex = testField.optionIndex(x)
      XCTAssertEqual(optionIndex, referenceIndex, "Index of option \(x) should be equal to \(referenceIndex), but it is \(optionIndex)")
    }
  }

  func test07values() {
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
      var updatedValues = [String]()
      var testField: TestField?
      override func didUpdate(#field: FormElement?) {
        XCTAssertEqual(field!, testField!)
        if let string = (field as? FormField<String, String>)?.currentValue {
          updatedValues.append(string)
        }
      }
    }

    let section = TestSection("TestSection")
    section.testField = testField
    section.append(testField)
    testField.currentValue = options[2]
    testField.internalValue = options[1]
    testField.currentValue = options[0]
    testField.internalValue = options[2]
    testField.currentValue = options[0]
    testField.currentValue = options[0]
    testField.currentValue = options[1]
    testField.internalValue = options[0]
    // setting the internalValue to the same value as currentValue does not update the field
    testField.currentValue = options[2]
    testField.internalValue = options[2]

    testField.reset(false)

    XCTAssertEqual(section.testField!.currentValue!, defaultValue, "Reset should return field to initial state")

    let reference = [options[1], options[2], options[0]]

    XCTAssertEqual(section.updatedValues, reference, "Field update should've triggered didUpdate method in section")
  }

}
