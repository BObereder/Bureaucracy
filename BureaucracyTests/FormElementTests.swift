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

  func test00elementHasSameNameAndAccessibilityLabel() {
    let element = FormElement("TestFormElement", cellClass: UITableViewCell.self)
    XCTAssertEqual(element.name, element.accessibilityLabel!, "Element's Name and AccessibilityLabel shoud be identical")
  }

  func test01danglingElementRaisesExceptionWhenGettingFieldIndex() {
    let element = FormElement("TestFormElement", cellClass: UITableViewCell.self)
    XCTAssertNil(element.section, "Section of dangling form element should be nil")
    XCTAssertNil(element.fieldIndex, "Index of dangling form element should be nil")
  }

  func test02serializedElementIsATupleOfNameAndNil() {
    let element = FormElement("TestFormElement", cellClass: UITableViewCell.self)
    let serialized = element.serialize()
    XCTAssertTrue(serialized.0 == "TestFormElement" && serialized.1 == nil, "Serialized element should be a tuple of name and nil")
  }

  func test03compareElements() {
    let element1 = FormElement("Element1", cellClass: FormCell.self)
    let element2 = FormElement("Element1", cellClass: FormCell.self)
    let element3 = element1

    XCTAssertNotEqual(element1, element2, "Elements should not be equal")
    XCTAssertEqual(element1, element3, "Elements should be equal")
  }

  func test04elementRegistersDequeuesAndConfiguresCell() {
    class CustomTableViewCell: FormCell { }

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
        return tableView.dequeueReusableCellWithIdentifier(CustomTableViewCell.description(), forIndexPath: indexPath) as UITableViewCell
      }
    }

    let element = FormElement("TestFormElement", cellClass: CustomTableViewCell.self)
    let viewController = TableViewController(element)
    let window = UIWindow(frame: CGRectMake(0, 0, 320, 480))
    window.rootViewController = viewController
    window.hidden = false

    let cell = element.dequeueReusableView(viewController.tableView, forIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    XCTAssertTrue(cell is CustomTableViewCell, "Should be able do dequeue CustomTableViewCell")

    element.configureCell(cell)
    XCTAssertNil(element.localizedTitle, "Localized title should initialize with nil")
    XCTAssertEqual(cell.accessibilityLabel, "\(element.accessibilityLabel).cell", "AcessibilityLabel should be set")
    XCTAssertEqual(cell.textLabel.text!, element.name, "Cell text label should be equal to Element's name if localizedTitle is nil")

    element.localizedTitle = "Localized title"
    element.configureCell(cell)
    XCTAssertEqual(cell.textLabel.text!, element.localizedTitle!, "Cell text label should be equal to Element's name localizedTitle")
  }

}
