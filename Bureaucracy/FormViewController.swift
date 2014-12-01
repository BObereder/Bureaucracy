//
//  FormViewController.swift
//  Bureaucracy
//
//  Created by Alexander Kolov on 20.10.14.
//  Copyright (c) 2014 Alexander Kolov. All rights reserved.
//

import UIKit

public class FormViewController: UITableViewController {

  public var dataSource: FormDataSource? {
    didSet {
      tableView.dataSource = dataSource
      dataSource?.register(tableView)
      tableView.reloadData()
    }
  }

  // MARK: - UITableViewDelegate

  public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    dataSource?.form.item(indexPath: indexPath).didSelect()
  }

}
