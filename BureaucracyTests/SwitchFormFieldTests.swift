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

class SwitchFormFieldTests: FormElementTests {

  typealias TestField = SwitchFormField<Bool, Bool>

  let options = [true, false]

  var defaultValue: Bool {
    return options[0]
  }

  var testField: TestField {
    return element as TestField
  }

  override func setUp() {
    super.setUp()
    element = TestField("TestSwitchFormField", value: options[0], options: options)
  }

  override func test01serialize() {
    let serialized = testField.serialize()
    XCTAssertTrue(serialized.0 == "TestSwitchFormField" && (serialized.1 as Bool) == true, "Serialized element should be a tuple of name and current value, but it is \(serialized)")
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
    XCTAssertEqual(testField.internalValue!, testField.option(testField.optionIndex(testField.currentValue!)), "Internal value should be equal to current value")
  }
  
  func test08switchControl() {
    
    class TableViewController: FormViewController, FormDelegate {
      
      override func viewDidLoad() {
        super.viewDidLoad()
        let filterForm = TestForm()
        filterForm.delegate = self
        form = filterForm
      }
      
      func getTestCell() -> SwitchFormCell {
        return tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as SwitchFormCell
      }
      
      override func didUpdateForm(form: Form, section: FormSection?, field: FormElement?) {
      }
    }
    
    class TestForm: Form {
      
      override init() {
        super.init()
        let testSection = FormSection("TestSection")
        testSection.append(SwitchFormField<Bool, Bool>("TestSwitchFormField", value: true, options: [true, false]))
        addSection(testSection)
      }
    }
    
    let viewController = TableViewController()
    viewController.view.frame = UIScreen.mainScreen().bounds

    XCTAssertNotNil(viewController.getTestCell().switchControl, "Switch control should not be nil")
    XCTAssertEqual(viewController.getTestCell().switchControl.accessibilityIdentifier, "TestSwitchFormField.cell.switch", "Acessibility label should be correct")
    XCTAssertEqual(viewController.getTestCell().switchControl.on, true, "Switch should be on")
    
    let element = viewController.getTestCell().formElement as? SwitchFormField<Bool, Bool>
    XCTAssertNotNil(element, "The cell should have an element")
    
    element!.internalValue = false
    XCTAssertEqual(viewController.getTestCell().switchControl.on, false, "Switch should be off")
    
    element!.reset(true)
    XCTAssertEqual(viewController.getTestCell().switchControl.on, true, "Reset should revert segmented control to initial state")
  }
}