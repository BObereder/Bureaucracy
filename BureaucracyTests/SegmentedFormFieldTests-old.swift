//
//  SegmentedFormFieldTests.swift
//  Bureaucracy
//
//  Created by Bernhard Obereder on 12.11.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit
import XCTest
import Bureaucracy

class SegmentedFormFieldTests: XCTestCase {
  
  class TestSegmentedFormField<>: SegmentedFormField {
    
    
  }
  
  var form: Form?
  var formDelegate: FormDelegate?
  
  override func setUp() {
    super.setUp()
    form = Form()
    formDelegate = FormTestDelegate()
    form?.delegate = formDelegate
  }
  
  func test01addStandardSegmentedFormField() {
    
    // Add Section and ForwardingElement
    let testSection = form!.addSection("Test Section")
    let segmentedField = SegmentedFormField<TestCountry>("SegmentedField", value: .Germany, options: [.Germany, .Austria])
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
    segmentedField.currentValue = .Germany
    XCTAssertTrue((form!.delegate! as FormTestDelegate).calledDidUpdateForm, "Value change did not update the FormDelegate")
    XCTAssertNil(segmentedField.error, "There should not be an error after setting the value")
    
    // Test Field
    XCTAssertEqual(segmentedField.representationValues!, ["Germany", "Austria"], "Representation is expected to return the values set in representationTransformer ")
  }
  
  func test02addCustomSegmentedFormField() {
    
    // Add Section and ForwardingElement
    let testSection = form!.addSection("Test Section")
    let segmentedField = SegmentedFormField<TestGender>("SegmentedField", value: .Female, options: [.Female, .Male])
    segmentedField.ty = { (var genderType) -> (Int) in
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
    XCTAssertEqual(segmentedField.description, ["Female", "Male"], "Representation is expected to return the values set in representationTransformer ")
  }
  
}