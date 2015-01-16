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

class SegmentedFormFieldTests: FormElementTests {

  typealias TestField = SwitchFormField<Bool, Bool>

  let options = [true, false]

  var defaultValue: String {
    return options[0]
  }

  var testField: TestField {
    return element as TestField
  }

  override func setUp() {
    super.setUp()
    element = TestField("TestSwitchFormField", value: options[0], options: options)
  }

  override func test01() {
  }
}