//
//  SizeSelectionListViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

protocol SelectionListViewOutput: AnyObject {
	func didSelectItem(_ size: Size)
}

private typealias SizeDataSource = UITableViewDiffableDataSource<SizeSelectionListViewController.Section, Size>
private typealias SizeDataSnapshot = NSDiffableDataSourceSnapshot<SizeSelectionListViewController.Section, Size>

class SizeSelectionListViewController: UIViewController {
	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	private lazy var dataSource: SizeDataSource = .init(tableView: tableView) { tableView, indexPath, item in
		guard let cell = tableView.dequeueReusableCell(withIdentifier: GenericSelectionListTableViewCell<Size>.reuseId, for: indexPath) as? GenericSelectionListTableViewCell<Size> else { return UITableViewCell() }
		var isSelected = false
		if item == SelectedSize.shared.size {
			isSelected = true
		}
		cell.configure(item: item, isSelected: isSelected)
		return cell
	}

	weak var output: SelectionListViewOutput?

	override func viewDidLoad() {
		super.viewDidLoad()
		title = LocaleStrings.selectSize
		setupLayout()
		applySnapshot()
	}

	private func setupLayout() {
		view.backgroundColor = Colors.backgroundColor.color
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.backgroundColor = .clear
		tableView.register(GenericSelectionListTableViewCell<Size>.self, forCellReuseIdentifier: GenericSelectionListTableViewCell<Size>.reuseId)
		tableView.snp.makeConstraints { make in
			make.leading.top.trailing.bottom.equalToSuperview()
		}
	}

	private func applySnapshot() {
		var snapshot = SizeDataSnapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(Size.sizes)
		dataSource.apply(snapshot, animatingDifferences: true)
	}
}

private extension SizeSelectionListViewController {
	enum Section {
		case main
	}
}

extension SizeSelectionListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if let selected = dataSource.itemIdentifier(for: indexPath) {
			SelectedSize.shared.size = selected
			output?.didSelectItem(selected)
			dismiss(animated: true)
		}
	}
}
