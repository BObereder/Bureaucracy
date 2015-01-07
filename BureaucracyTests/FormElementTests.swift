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

  var element: FormElement?

  override func setUp() {
    super.setUp()
    element = FormElement("TestFormElement")
  }

  func test00initialization() {
    XCTAssertNil(element!.section, "Section of dangling form element should be nil")
    XCTAssertNil(element!.fieldIndex, "Index of dangling form element should be nil")
  }

  func test01serialize() {
    let serialized = element!.serialize()
    XCTAssertTrue(serialized.0 == "TestFormElement" && serialized.1 == nil, "Serialized element should be a tuple of name and nil")
  }

  func test02comparison() {
    let element1 = FormElement("Element1")
    let element2 = element!

    XCTAssertNotEqual(element!, element1, "Elements should not be equal")
    XCTAssertEqual(element!, element2, "Elements should be equal")
  }

  func test03userInterface() {
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
        theElement?.register(tableView)
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

    let element = FormElement("TestFormElement")
    let viewController = TableViewController(element)
    let window = UIWindow(frame: CGRectMake(0, 0, 320, 480))
    window.rootViewController = viewController
    window.hidden = false

    let cell = element.dequeueReusableView(viewController.tableView, forIndexPath: NSIndexPath(forRow: 0, inSection: 0))

    element.configureCell(cell)
    XCTAssertNil(element.localizedTitle, "Localized title should initialize with nil")
    XCTAssertEqual(cell.accessibilityIdentifier, "\(element.name).cell", "Acessibility identifier should be set")
    XCTAssertEqual(cell.textLabel!.text!, element.name, "Cell text label should be equal to Element's name if localizedTitle is nil")

    element.localizedTitle = "Localized title"
    element.configureCell(cell)
    XCTAssertEqual(cell.textLabel!.text!, element.localizedTitle!, "Cell text label should be equal to Element's name localizedTitle")
  }

}
