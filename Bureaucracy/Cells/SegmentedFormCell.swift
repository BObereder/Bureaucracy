//
//  SegmentedFormCell.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class SegmentedFormCell: FormCell {

  @IBOutlet weak var segmentedControl: UISegmentedControl!

  @IBAction public func didChangeValue(sender: UISegmentedControl) {
    formField?.formValue = sender.selectedSegmentIndex
  }

  // MARK: - FormCell

  public override func update() {
    segmentedControl.removeAllSegments()

    if let field = formField as? SegmentedFormField {
      for title in field.segments {
        segmentedControl.insertSegmentWithTitle(title, atIndex: segmentedControl.numberOfSegments, animated: false)
      }

      if let index = formField?.formValue as? Int {
        segmentedControl.selectedSegmentIndex = index
      }
    }
  }

}
