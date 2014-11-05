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

enum TestGender: Int {
  case Female = 2
  case Male = 3
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
    XCTAssertTrue(form!.serialize().isEmpty, "values function of an empty array should return an empty array")
  }
  
  func test01addSection() {
    form!.addSection("Test Section")
    XCTAssertEqual(form!.numberOfSections(), 1, "Form should contain a section after adding")
    XCTAssertEqual(form!.numberOfFieldsInSection(0), 0, "Section should not have any Elements yet")
    XCTAssertFalse(form!.serialize().isEmpty, "values function should return something when there is a section")
    if let section = form!.serialize().first {
      XCTAssertTrue(section.isEmpty, "the section values should be empty since there are no Elements added")
    }
    
    // is section setup correct
    let section = form!.sections.first!
    XCTAssertEqual(section.name, "Test Section", "Form should have the title set correct")
    XCTAssertTrue(section.form === form, "Form property of the section should be the form of the testclass")
    XCTAssertEqual(section.count, 0, "Section should contain elements yet")
  }
  
  func test02addForwardingElement() {
    
    //Add Section and ForwardingElement
    let testSection = form!.addSection("Test Section")
    let allProductsField = testSection.append(ForwardingElement(name: "Test Element"))
    
    allProductsField.didSelect = { () in
      allProductsField.formSection!.form.delegate!.didUpdateForm(allProductsField.formSection!.form)
    }
    
    //Test Form
    XCTAssertTrue(form?.item(indexPath: NSIndexPath(forRow: 0, inSection: 0)) === allProductsField, "Wrong element is returned from form")
    XCTAssertEqual(form!.numberOfFieldsInSection(0), 1, "Section should have an Element")
    let values = form!.serialize()
    XCTAssertNotNil(values.isEmpty, "Their should be a value since there is an element in the section")
    XCTAssertFalse(values.first?["Test Element"] == nil, "element should not have a value")
    
    // Test Selection
    allProductsField.didSelect()
    XCTAssertTrue((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Selection did not update the form")
    
  }
  
  func test03addSegmentedFormField() {
    
    //Add Section and ForwardingElement
    let testSection = form!.addSection("Test Section")
    let segmentedField = SegmentedFormField<TestGender, Int, String>(name: "SegmentedField", value: .Female, values: [.Female, .Male])
    
    segmentedField.valueTransformer = { (var genderType) -> (Int) in
      switch genderType {
      case .Female:
        return 0
      case .Male:
        return 1
      default:
        return 0
      }
    }
    
    segmentedField.reverseValueTransformer = { (var segmentedIndex) -> (TestGender) in
      switch segmentedIndex {
      case 0:
        return .Female
      case 1:
        return .Male
      default:
        return .Female
      }
    }
    
    segmentedField.representationTransformer = { (var genderType) -> String in
      switch genderType {
      case .Female:
        return NSLocalizedString("Female", comment: "Female gender")
      case .Male:
        return NSLocalizedString("Male", comment: "Male gender")
      default:
        return NSLocalizedString("Female", comment: "Female gender")
      }
    }
    
    testSection.append(segmentedField)
    
    //Test Form
    XCTAssertTrue(form?.item(indexPath: NSIndexPath(forRow: 0, inSection: 0)) === segmentedField, "Wrong element is returned from form")
    XCTAssertEqual(form!.numberOfFieldsInSection(0), 1, "Section should have an Element")
    let values = form!.serialize()
    XCTAssertNotNil(values.isEmpty, "Their should be a value since there is an element in the section")
//    XCTAssertFalse(values.first?["SegmentedField"] == .Female, "element should not have a value")
//    
//    // Test Selection
//    allProductsField.didSelect()
//    XCTAssertTrue((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Selection did not update the form")
    
    
  }
  
}
