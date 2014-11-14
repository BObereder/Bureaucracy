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

  func test01serialize() {
    let empty = testSection!.serialize()
    XCTAssertEqual(empty.count, 0, "Serialized form of empty section should also be empty")


  }

  func test02comparison() {

  }

}
