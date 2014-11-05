//
//  BureaucracyTests.swift
//  BureaucracyTests
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit
import XCTest
import Bureaucracy

class FormTestDelegate: FormDelegate {

  var calledDidUpdateForm: Bool = false
  
  func didUpdateForm(form: Form) {
    calledDidUpdateForm = true
  }
}

class FormSetupHelper {

  class func addSection(form: Form?) {
  
  
  }
}


class BureaucracyTests: XCTestCase {
  
  var form: Form?
  var formDelegate: FormDelegate?

  override func setUp() {
    super.setUp()
    form = Form()
    formDelegate = FormTestDelegate()
    form?.delegate = formDelegate
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test00emptyForm() {
    XCTAssertEqual(form!.numberOfSections(), 0, "Form should be empty after init")
    XCTAssertEqual(form!.numberOfFieldsInSection(1), 0, "Form should be empty after init")
    XCTAssertTrue(form!.values().isEmpty, "values function of an empty array should return an empty array")
  }
  
  func test01addSection() {
    form?.addSection("Test Section")
    XCTAssertEqual(form!.numberOfSections(), 1, "Form should contain a section after adding")
    XCTAssertEqual(form!.numberOfFieldsInSection(1), 0, "Section should not have any Elements yet")
    XCTAssertFalse(form!.values().isEmpty, "values function should return something when there is a section")
    if let section = form!.values().first {
      XCTAssertTrue(section.isEmpty, "the section values should be empty since there are no Elements added")
    }
    
    // is section setup correct
    let section = form!.sections.first!
    if let title = section.title {
      XCTAssertEqual(title, "Test Section", "Form should have the title set correct")
    }
    XCTAssertTrue(section.form === form, "Form property of the section should be the form of the testclass")
    XCTAssertEqual(section.numberOfFields(), 0, "Section should contain elements yet")
  }
  
  func test02addFormElement() {
    let testSection = form?.addSection("Test Section")
    let allProductsField = testSection.addElement(ForwardingElement(formSection: allProductsSection))
    allProductsField.title = NSLocalizedString("All Products", comment: "All Products")
    allProductsField.didSelect = { [unowned self] () in
      self.didSelectFormElement()
    }
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measureBlock() {
      // Put the code you want to measure the time of here.
    }
  }
  
}
