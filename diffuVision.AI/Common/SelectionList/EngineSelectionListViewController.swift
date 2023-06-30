//
//  EngineSelectionListViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 1.07.2023.
//

import UIKit

protocol EngineSelectionListViewOutput: AnyObject {
	func didSelectItem(_ engine: Engine)
}

private typealias DataSource = UITableViewDiffableDataSource<EngineSelectionListViewController.Section, Engine>
private typealias DataSnapshot = NSDiffableDataSourceSnapshot<EngineSelectionListViewController.Section, Engine>

class EngineSelectionListViewController: UIViewController {
	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
	var engines: [Engine] = []

	private lazy var dataSource: DataSource = .init(tableView: tableView) { tableView, indexPath, item in
		guard let cell = tableView.dequeueReusableCell(withIdentifier: GenericSelectionListTableViewCell<Engine>.reuseId,
		                                               for: indexPath) as? GenericSelectionListTableViewCell<Engine> else { return UITableViewCell() }
		var isSelected = false
		if item.id == SelectedItem.shared.engine.id {
			isSelected = true
		}
		cell.configure(item: item, isSelected: isSelected)
		return cell
	}

	weak var output: EngineSelectionListViewOutput?

	override func viewDidLoad() {
		super.viewDidLoad()
		title = LocaleStrings.selectEngine
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocaleStrings.doneButton, style: .done, target: self, action: #selector(dismissView))
		setupLayout()
		applySnapshot()
	}

	private func setupLayout() {
		view.backgroundColor = Colors.backgroundColor.color
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.backgroundColor = .clear
		tableView.register(GenericSelectionListTableViewCell<Engine>.self, forCellReuseIdentifier: GenericSelectionListTableViewCell<Engine>.reuseId)
		tableView.snp.makeConstraints { make in
			make.leading.top.trailing.bottom.equalToSuperview()
		}
	}

	private func applySnapshot() {
		var snapshot = DataSnapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(engines)
		dataSource.apply(snapshot, animatingDifferences: true)
	}

	@objc private func dismissView() {
		dismiss(animated: true)
	}
}

private extension EngineSelectionListViewController {
	enum Section {
		case main
	}
}

extension EngineSelectionListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if let selected = dataSource.itemIdentifier(for: indexPath) {
			SelectedItem.shared.engine = selected
			output?.didSelectItem(selected)
			dismissView()
		}
	}
}
