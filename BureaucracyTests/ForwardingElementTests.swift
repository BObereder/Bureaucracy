//
//  ForwardingElementTests.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 12.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit
import XCTest
import Bureaucracy

class ForwardingElementTests: XCTestCase {
  
  class TestForwardingElement: ForwardingElement {
    
    override func didSelect() {
      section!.form!.delegate!.didUpdateForm(section!.form!, section: section, field: self)
    }
  }
  
  var form: Form?
  var formDelegate: FormDelegate?
  
  override func setUp() {
    super.setUp()
    form = Form()
    formDelegate = FormTestDelegate()
    form?.delegate = formDelegate
  }
  
  func test01addForwardingElement() {
    
    // Add Section and ForwardingElement
    let testSection = form!.addSection("Test Section")
    let allProductsField = testSection.append(TestForwardingElement("Test Element"))
    
    // Test Form
    XCTAssertTrue(form?.item(indexPath: NSIndexPath(forRow: 0, inSection: 0)) === allProductsField, "Expected the field that was previously added to the form")
    XCTAssertEqual(form!.numberOfFieldsInSection(0), 1, "Section should have an element")
    let values = form!.serialize()
    XCTAssertFalse(values.isEmpty, "There should be a value since there is an element in the section")
    XCTAssertEqual(values.count, 1, "There should only be one value since there is only one element in the section")
    XCTAssertFalse(values.first?["Test Element"] == nil, "ForwardingElement should not have a value")
    
    // Test Selection
    allProductsField.didSelect()
    XCTAssertTrue((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Selection did not update the form")
  }
}