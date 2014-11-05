//
//  FormViewController.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class FormViewController: UIViewController, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!

  public var dataSource: FormDataSource? {
    didSet {
      tableView.dataSource = dataSource
      dataSource?.registerReusableViews(tableView)
    }
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
  }

  // MARK: - UITableViewDelegate

  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    dataSource?.form.elementAtIndex(indexPath).didSelect()
  }

}
