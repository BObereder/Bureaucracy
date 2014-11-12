//
//  FormElementTests.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 12.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Bureaucracy
import UIKit
import XCTest

class FormElementTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testThatElementHasSameNameAndAccessibilityLabel() {
    let element = FormElement("TestFormElement", nil)
    XCTAssertEqual(element.name, element.accessibilityLabel, "Element's Name and AccessibilityLabel shoud be identical")
  }

}
