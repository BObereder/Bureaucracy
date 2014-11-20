//
//  FormSectionTests.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 14.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Bureaucracy
import UIKit
import XCTest

class FormSectionTests: XCTestCase {

  let testSectionName = "TestSection"
  var testSection: FormSection?

  override func setUp() {
    super.setUp()
    testSection = FormSection(self.testSectionName)
  }

  func test00initialization() {
    XCTAssertEqual(testSection!.name, testSectionName, "Section name should be equal to \(testSectionName) but it is \(testSection!.name)")
    XCTAssertNil(testSection!.form, "Initial form value should be nil")
    XCTAssertNil(testSection!.sectionIndex, "Initial section index should be nil")
  }

  func test01fields() {
    XCTAssertEqual(testSection!.count, 0, "Should start with zero fields")

    let element = FormElement("TestElement")
    let appended = testSection!.append(element)
    XCTAssertEqual(appended, element, "Should return the appeneded element")
    XCTAssertEqual(testSection!.count, 1, "Section count should be 1, but it is \(testSection!.count)")

    testSection!.removeAll()
    XCTAssertEqual(testSection!.count, 0, "Section count should be 0, but it is \(testSection!.count)")
  }

  func test02fieldGeneratorAndSubscript() {
    var elements1: [FormElement] = []
    for i in 0..<10 {
      let el = FormElement("TestElement-\(i)")
      testSection!.append(el)
      elements1.append(el)
    }

    XCTAssertEqual(testSection!.count, 10, "Section count should be 10, but it is \(testSection!.count)")

    var elements2: [FormElement] = []
    for el in testSection! {
      elements2.append(el)
    }

    XCTAssertEqual(elements1, elements2, "\(elements1) should equal \(elements2)")

    var elements3: [FormElement] = []
    for i in 0..<10 {
      elements3.append(testSection![i])
    }

    XCTAssertEqual(elements1, elements3, "\(elements1) should equal \(elements3)")
  }

  func test02comparison() {
    let section1 = testSection!
    let section2 = FormSection(self.testSectionName)
    XCTAssertEqual(testSection!, section1, "Sections should be equal")
    XCTAssertNotEqual(section1, section2, "Sections should not be equal")
  }

  func test04serialize() {
    let empty = testSection!.serialize()
    XCTAssertEqual(empty.count, 0, "Serialized form of empty section should also be empty")

    let element = FormElement("TestElement")
    let field = FormField<String, String>("TestField", value: "zero", options: ["zero", "one", "two"])
    let segmentedField = SegmentedFormField<String, Int>("SegmentedTestField", value: "segment0", options: ["segment0", "segment1", "segment2"])

    testSection!.append(element)
    testSection!.append(field)
    testSection!.append(segmentedField)

    let serialized = testSection!.serialize()
    let serializedTestElement = serialized["TestElement"]!
    let serializedTestField = serialized["TestField"] as String
    let serializedSegmentedTestField = serialized["SegmentedTestField"] as String
    XCTAssertTrue(serializedTestElement == nil, "Value of TestElement should be nil, but it is \(serializedTestElement)")
    XCTAssertEqual(serializedTestField, "zero", "Value of TestField should be zero, but it is \(serializedTestField)")
    XCTAssertEqual(serializedSegmentedTestField, "segment0", "Value of TestField should be segment0, but it is \(serializedSegmentedTestField)")
  }

  func test05updating() {
    class TestFormSection: FormSection {
      var updatedFields = [FormElement]()
      override func didUpdate(#field: FormElement?) {
        super.didUpdate(field: field)
        updatedFields.append(field!)
      }
    }

    let section = TestFormSection("TestFormSection")
    let field = FormField<String, String>("TestField", value: "zero", options: ["zero", "one", "two"])
    let segmentedField = SegmentedFormField<String, Int>("SegmentedTestField", value: "segment0", options: ["segment0", "segment1", "segment2"])

    section.append(field)
    section.append(segmentedField)

    field.currentValue = "one"

    XCTAssertEqual(section.updatedFields.count, 0, "There should be no update event")
    XCTAssertEqual(field.internalValue!, "one", "Internal value of TestField should be one, but it is \(field.internalValue)")

    segmentedField.internalValue = 2

    XCTAssertEqual(section.updatedFields[0], segmentedField, "SegmentedTestField should be the second field updated")
    XCTAssertEqual(segmentedField.currentValue!, "segment2", "Current value of TestField should be segment2, but it is \(segmentedField.currentValue)")
  }

}
