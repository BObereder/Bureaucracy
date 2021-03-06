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
  
  func didUpdateForm(form: Form, section: FormSection?, item: FormElement?) {
    calledDidUpdateForm = true
  }
}

enum TestGender: Int, Printable {
  case Unknown = 0
  case Female = 2
  case Male = 3
  
  var description: String {
    switch self {
    case .Female:
      return "Female"
    case .Male:
      return "Male"
    case .Unknown:
      return "Unknown Gender"
    }
  }
}

enum TestCountry: Int, Printable {
  case Unknown = 0
  case Germany = 2
  case Austria = 3
  
  var description: String {
    switch self {
    case .Germany:
      return "Germany"
    case .Austria:
      return "Austria"
    case .Unknown:
      return "Unknown Country"
    }
  }
}

func ==(lhs: AllProducts, rhs: AllProducts) -> Bool {
  return true
}

struct AllProducts: Equatable, Printable {
  
  static var sharedInstance : AllProducts {
    struct Static {
      static let instance : AllProducts = AllProducts()
    }
    return Static.instance
  }
  
  var description: String {
    return NSLocalizedString("categories.all", comment: "All products")
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
  }
  
  func test00emptyForm() {
    XCTAssertEqual(form!.numberOfSections(), 0, "Form should be empty after init")
    XCTAssertTrue(form!.serialize().isEmpty, "values function of an empty array should return an empty array")
  }
  
  func test01addSection() {
    form!.addSection("Test Section")
    XCTAssertEqual(form!.numberOfSections(), 1, "Form should contain a section after adding")
    XCTAssertEqual(form!.numberOfFieldsInSection(0), 0, "Section should not have any elements yet")
    XCTAssertFalse(form!.serialize().isEmpty, "Serialize function should return something when there is a section")
    XCTAssertEqual(form!.serialize().count, 1, "Serialize function should return only one element since there is only one section")
    if let section = form!.serialize().first {
      XCTAssertTrue(section.isEmpty, "The section values should be empty since there are no elements added yet")
    }
    
    // Section Setup
    let section = form!.sections.first!
    XCTAssertEqual(section.name, "Test Section", "Form should have the title set correct")
    XCTAssertTrue(section.form === form, "Form property of the section should be the form of the testclass")
    XCTAssertEqual(section.count, 0, "Section should not contain elements yet")
  }
  
  func test02addForwardingElement() {
    
    // Add Section and ForwardingElement
    let testSection = form!.addSection("Test Section")
    let allProductsField = testSection.append(ForwardingElement("Test Element"))
    
    allProductsField.didSelect = {
      allProductsField.formSection!.form!.delegate!.didUpdateForm(allProductsField.formSection!.form!, section: testSection, item: allProductsField)
    }
    
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
  
  func test03addStandardSegmentedFormField() {
    
    // Add Section and ForwardingElement
    let testSection = form!.addSection("Test Section")
    let segmentedField = SegmentedFormField<TestCountry, Int, String>("SegmentedField", value: .Germany, values: [.Germany, .Austria])
    testSection.append(segmentedField)
    
    // Test Form
    XCTAssertTrue(form?.item(indexPath: NSIndexPath(forRow: 0, inSection: 0)) === segmentedField, "Expected the field that was previously added to the form")
    XCTAssertEqual(form!.numberOfFieldsInSection(0), 1, "Section should have an Element")
    var values = form!.serialize()
    XCTAssertFalse(values.isEmpty, "Their should be a value since there is an element in the section")
    XCTAssertEqual(values.count, 1, "There should only be one value since there is only one element in the section")
    var country = values.first!["SegmentedField"] as TestCountry
    XCTAssertEqual(country, TestCountry.Germany, "value of SegmentedField has not expected value")
    
    // Test Selection
    segmentedField.internalValue = 1
    values = form!.serialize()
    XCTAssertFalse(values.isEmpty, "Their should be a value since there is an element in the section")
    country = values.first!["SegmentedField"] as TestCountry
    XCTAssertEqual(country, TestCountry.Austria, "value of SegmentedField has not expected value")
    
    // Test if Delegate is called
    XCTAssertTrue((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Selection did not update the form")
    
    // Reset FormDelegate
    (form!.delegate! as FormTestDelegate).calledDidUpdateForm = false
    // Just to be sure it is reset
    XCTAssertFalse((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Should be reset")
    
    // Test Field Validation
    segmentedField.value = .Germany
    XCTAssertTrue((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Value change did not update the FormDelegate")
    XCTAssertNil(segmentedField.error, "There should not be an error after setting the value")
    
    // Test Field
    XCTAssertEqual(segmentedField.representationValues!, ["Germany", "Austria"], "Representation is expected to return the values set in representationTransformer ")
  }
  
  func test04addCustomSegmentedFormField() {
    
    // Add Section and ForwardingElement
    let testSection = form!.addSection("Test Section")
    
    let transformer: TestGender -> Int = { (var genderType) -> (Int) in
      switch genderType {
      case .Female:
        return 0
      case .Male:
        return 1
      default:
        return 0
      }
    }
    
    let reverse: Int -> TestGender = { (var segmentedIndex) -> (TestGender) in
      switch segmentedIndex {
      case 0:
        return .Female
      case 1:
        return .Male
      default:
        return .Female
      }
    }
    
    let segmentedField = SegmentedFormField<TestGender, Int, String>("SegmentedField", value: .Female, values: [.Female, .Male], transformer: transformer, reverse: reverse)
    segmentedField.validator = { (var genderType) -> NSError? in
      switch genderType {
      case .Female, .Male:
        return nil
      case .Unknown:
        return NSError()
      default:
        return NSError()
      }
    }

    testSection.append(segmentedField)
    
    // Test Form
    XCTAssertTrue(form?.item(indexPath: NSIndexPath(forRow: 0, inSection: 0)) === segmentedField, "Expected the field that was previously added to the form")
    XCTAssertEqual(form!.numberOfFieldsInSection(0), 1, "Section should have an Element")
    var values = form!.serialize()
    XCTAssertFalse(values.isEmpty, "There should be a value since there is an element in the section")
    XCTAssertEqual(values.count, 1, "There should only be one value since there is only one element in the section")
    var gender = values.first!["SegmentedField"] as TestGender
    XCTAssertEqual(gender, TestGender.Female, "value of SegmentedField has not expected value")
    
    // Test Selection
    segmentedField.internalValue = 1
    values = form!.serialize()
    gender = values.first!["SegmentedField"] as TestGender
    XCTAssertEqual(gender, TestGender.Male, "Expected gender to be Male after selection")
    
    // Test if Delegate is called
    XCTAssertTrue((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Selection did not update the FormDelegate")
    
    // Reset FormDelegate
    (form!.delegate! as FormTestDelegate).calledDidUpdateForm = false
    // Just to be sure it is reset
    XCTAssertFalse((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Should be reset")
    
    // Test Field Validation with valid value
    segmentedField.value = .Female
    XCTAssertTrue((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Value change did not update the FormDelegate")
    XCTAssertNil(segmentedField.error, "There should not be an error after setting the value")
    
    // Reset FormDelegate
    (form!.delegate! as FormTestDelegate).calledDidUpdateForm = false
    // Just to be sure it is reset
    XCTAssertFalse((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Should be reset")
    
    // Test Field Validation with invalid value
    segmentedField.value = .Unknown
    XCTAssertFalse((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Expected that FormDelegate did not update when setting invalid value")
    // XCTAssertNotNil crashes here
    XCTAssertTrue(segmentedField.error != nil, "There should be an error after setting an invalid value")
    
    // Test Field
    XCTAssertEqual(segmentedField.representationValues!, ["Female", "Male"], "Representation is expected to return the values set in representationTransformer ")
  }
  
  func test05AccessibilityTest() {
    // Add Section and Elements
    let testSection = form!.addSection("Test Section")
    let testElement = testSection.append(ForwardingElement("Test Element"))
    let segmentedField = SegmentedFormField<TestCountry, Int, String>("SegmentedField", value: .Germany, values: [.Germany, .Austria])
    testSection.append(segmentedField)
    
    // All Products Section
    var section = SelectorFormSection("allProducts", value: AllProducts.sharedInstance, values: [AllProducts.sharedInstance])
    let allProductsSection = form!.addSection(section)
    
    // Setup FormViewController and DataSoure
    let formVC = FormViewController()
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    formVC.tableView = tableView
    formVC.dataSource = FormDataSource(form: form!)
    formVC.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
    formVC.view.addSubview(tableView)
    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    window.rootViewController = formVC
    window.hidden = false
    
    // ForwardingCell
    let forwardingCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    XCTAssertEqual(forwardingCell!.accessibilityLabel!, "ForwardingElement", "Cell is expected to have the standard accessibilityLabel")
    
    // SegmentedCell
    let segmentedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as SegmentedFormCell
    let segmentedControl = segmentedCell.segmentedControl
    XCTAssertEqual(segmentedControl!.accessibilityLabel!, "SegmentedFormField", "SegmentedControll of SegmentedFormCell is expected to have the standard accessibilityLabel")
    
    // SelectorGroupFormField
    let selectorGroupFormFieldCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
    XCTAssertEqual(selectorGroupFormFieldCell!.accessibilityLabel!, "allProducts.0", "Cell is expected to have the standard accessibilityLabel")
    
    // test setting accessibility
    testElement.accessibilityLabel = "TestForwardingField"
    segmentedField.accessibilityLabel = "TestSegmentedField"
    var item = section.items.first as SelectorGroupFormField
    item.accessibilityLabel = "TestSelectorGroupFormField"
    
    formVC.tableView.reloadData()
    
    // ForwardingCell
    let customForwardingCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    XCTAssertEqual(customForwardingCell!.accessibilityLabel!, "TestForwardingField", "Cell is expected to have the standard accessibilityLabel")
    
    // SegmentedCell
    let customSegmentedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as SegmentedFormCell
    XCTAssertEqual(customSegmentedCell.segmentedControl!.accessibilityLabel!, "TestSegmentedField", "SegmentedControll of SegmentedFormCell is expected to have the standard accessibilityLabel")
    
    // SelectorGroupFormField
    let customSelectorGroupFormFieldCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
    XCTAssertEqual(customSelectorGroupFormFieldCell!.accessibilityLabel!, "TestSelectorGroupFormField", "Cell is expected to have the standard accessibilityLabel")
  }
  
}
