//
//  FormTests.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 18.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Bureaucracy
import UIKit
import XCTest

class FormTests: XCTestCase {

  let testForm = Form()

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  func test00fields() {
    XCTAssertEqual(testForm.numberOfSections, 0, "Should start with zero sections")

    let section1 = testForm.addSection("TestSection1")
    XCTAssertEqual(section1, testForm.sections[0], "Should be able to create sections by name")
    XCTAssertEqual(testForm.numberOfSections, 1, "Number of sections should equal to 1")

    let aSection = FormSection("TestSection2")
    let section2 = testForm.addSection(aSection)
    XCTAssertEqual(aSection, testForm.sections[1], "Should be able to append sections")
    XCTAssertEqual(aSection, section2, "Should return appended section")
    XCTAssertEqual(testForm.numberOfSections, 2, "Number of sections should equal to 2")

    for section in [section1, section2] {
      let element1 = FormElement("\(section.name)-TestElement1")
      section.append(element1)

      let element2 = FormField<Int, Int>("\(section.name)-TestElement2", value: 0, options: [0, 1, 2])
      section.append(element2)

      let element3 = SegmentedFormField<String>("\(section.name)-TestElement3", value: "A", options: ["A", "B", "C"])
      section.append(element3)
    }

    for i in 0..<2 {
      XCTAssertEqual(testForm.numberOfFieldsInSection(i), 3, "Number of fields in section \(i) should be equal to 3")
      for j in 0..<3 {
        XCTAssertEqual(testForm.item(indexPath: NSIndexPath(forItem: j, inSection: i)), testForm.sections[i][j], "Element at index path should be equal to element in section by index")
      }
    }

    var i = 0
    for section in testForm {
      XCTAssertEqual(section, testForm.sections[i++], "Section via generator should be equal to element in sections array")
    }
  }

  func test01serialization() {
    let section1 = testForm.addSection("TestSection1")
    let section2 = testForm.addSection("TestSection2")

    for section in [section1, section2] {
      let element1 = FormElement("\(section.name)-TestElement1")
      section.append(element1)

      let element2 = FormField<Int, Int>("\(section.name)-TestElement2", value: 0, options: [0, 1, 2])
      section.append(element2)

      let element3 = SegmentedFormField<String>("\(section.name)-TestElement3", value: "A", options: ["A", "B", "C"])
      section.append(element3)
    }

    let serialized = testForm.serialize()

    var i = 0
    for section in serialized {
      let element1 = section["TestSection\(i)-TestElement1"] as Any?
      let element2 = section["TestSection\(i)-TestElement2"] as Int
      let element3 = section["TestSection\(i)-TestElement3"] as String
      XCTAssertTrue(element1 == nil, "First section element serialized value should be nil")
      XCTAssertEqual(element2, 0, "Second section element serialized value should be 0")
      XCTAssertEqual(element3, "A", "Third section element serialized value should be A")
    }
  }

  func test03updatePropagation() {
    class TestFormDelegate: FormDelegate {
      var updatedForm: Form?
      var updatedSection: FormSection?
      var updatedField: FormElement?

      init() {}

      func didUpdateForm(form: Form, section: FormSection?, field: FormElement?) {
        updatedForm = form
        updatedSection = section
        updatedField = field
      }
    }

    let delegate = TestFormDelegate()
    let field = testForm.addSection("TestSection").append(SegmentedFormField<String>("TestField", value: "A", options: ["A", "B", "C"]))
    testForm.delegate = delegate

    let segmentedField = (field as? SegmentedFormField<String>)!
    segmentedField.currentValue = "B"

    XCTAssertTrue(delegate.updatedForm! === testForm, "Form should have been updated")
    XCTAssertEqual(delegate.updatedSection!, testForm.sections[0], "Section should have been updated")
    XCTAssertEqual(delegate.updatedField!, segmentedField, "Field should have been updated")
    XCTAssertEqual((delegate.updatedField as? SegmentedFormField<String>)!.internalValue!, 1, "Internal value of the updated field should have changed")
  }

}
