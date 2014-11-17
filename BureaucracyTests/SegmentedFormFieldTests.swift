//
//  SegmentedFormFieldTests.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 13.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import Bureaucracy
import UIKit
import XCTest

class SegmentedFormFieldTest: FormElementTests {

  typealias TestField = SegmentedFormField<String>

  let options = ["One", "Two", "Three"]

  var defaultValue: String {
    return options[0]
  }

  var testField: TestField {
    return element as TestField
  }

  override func setUp() {
    super.setUp()
    element = SegmentedFormField("TestSegmentedFormField", value: options[0], options: options)
  }

  override func test01serialize() {
    let serialized = testField.serialize()
    XCTAssertTrue(serialized.0 == "TestSegmentedFormField" && (serialized.1 as String) == "One", "Serialized element should be a tuple of name and current value, but it is \(serialized)")
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
    XCTAssertEqual(testField.internalValue!, testField.optionIndex(testField.currentValue!), "Internal value should be equal to current value")

    testField.internalValue = 2
    XCTAssertEqual(testField.currentValue!, options[2], "Updated field value should be equal to \(options[2]), but it is \(testField.currentValue)")
    XCTAssertEqual(testField.previousValue!, options[1], "Previous field value should be equal to \(options[1]), but it is \(testField.previousValue)")
    XCTAssertEqual(testField.internalValue!, testField.optionIndex(testField.currentValue!), "Internal value should be equal to the option index of current value")
  }

  func test08segmentedControl() {
    class TableViewController: UITableViewController {

      init(_ element: FormElement) {
        theElement = element
        super.init(nibName: nil, bundle: nil)
      }

      required init(coder aDecoder: NSCoder) {
        theElement = nil
        super.init(coder: aDecoder)
      }

      var theElement: FormElement?

      override func viewDidLoad() {
        theElement?.registerReusableView(tableView)
      }

      override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
      }

      override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
      }

      override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier(FormCell.description(), forIndexPath: indexPath) as UITableViewCell
      }
    }

    let viewController = TableViewController(testField)
    let window = UIWindow(frame: CGRectMake(0, 0, 320, 480))
    window.rootViewController = viewController
    window.hidden = false

    let cell = testField.dequeueReusableView(viewController.tableView, forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as SegmentedFormCell

    testField.configureCell(cell)
    XCTAssertNotNil(cell.segmentedControl, "Segmented control should not be nil")
    XCTAssertEqual(cell.segmentedControl.accessibilityLabel, "SegmentedControl", "Acessibility label should be equal to SegmentedControl")
    XCTAssertEqual(cell.segmentedControl.selectedSegmentIndex, 0, "Segment 0 should be selected")

    for i in 0..<options.count {
      let segmentTitle = cell.segmentedControl.titleForSegmentAtIndex(i)!
      let elementTitle = options[i]
      XCTAssertEqual(segmentTitle, elementTitle, "Title of segment \(i) should be equal to \(elementTitle), but it is \(segmentTitle)")
    }

    testField.currentValue = options[1]
    XCTAssertEqual(cell.segmentedControl.selectedSegmentIndex, 1, "Segment 1 should be selected")

    cell.segmentedControl.selectedSegmentIndex = 2
    XCTAssertEqual(testField.currentValue!, options[2], "Segment 2 should be selected")
  }

}
