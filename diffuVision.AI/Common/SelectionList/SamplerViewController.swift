//
//  SamplerViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 8.07.2023.
//

import UIKit

protocol SamplerViewOutput: AnyObject {
	func didSelectItem(_ sampler: SamplerModel)
}

private typealias DataSource = UITableViewDiffableDataSource<SamplerViewController.Section, SamplerModel>
private typealias DataSnapshot = NSDiffableDataSourceSnapshot<SamplerViewController.Section, SamplerModel>

class SamplerViewController: UIViewController {
	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	private lazy var dataSource: DataSource = .init(tableView: tableView) { tableView, indexPath, item in
		guard let cell = tableView.dequeueReusableCell(withIdentifier: GenericSelectionListTableViewCell<SamplerModel>.reuseId,
		                                               for: indexPath) as? GenericSelectionListTableViewCell<SamplerModel> else { return UITableViewCell() }
		var isSelected = false
		if item == SelectedItem.shared.sampler {
			isSelected = true
		}
		cell.configure(item: item, isSelected: isSelected)
		return cell
	}

	weak var output: SamplerViewOutput?

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Clip Guidence Preset"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocaleStrings.doneButton, style: .done, target: self, action: #selector(dismissView))
		setupLayout()
		applySnapshot()
	}

	private func setupLayout() {
		view.backgroundColor = Colors.backgroundColor.color
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.backgroundColor = .clear
		tableView.register(GenericSelectionListTableViewCell<SamplerModel>.self, forCellReuseIdentifier: GenericSelectionListTableViewCell<SamplerModel>.reuseId)
		tableView.snp.makeConstraints { make in
			make.leading.top.trailing.bottom.equalToSuperview()
		}
	}

	private func applySnapshot() {
		var snapshot = DataSnapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(SamplerModel.samplers)
		dataSource.apply(snapshot, animatingDifferences: true)
	}

	@objc private func dismissView() {
		dismiss(animated: true)
	}
}

private extension SamplerViewController {
	enum Section {
		case main
	}
}

extension SamplerViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if let selected = dataSource.itemIdentifier(for: indexPath) {
			SelectedItem.shared.sampler = selected
			output?.didSelectItem(selected)
			dismissView()
		}
	}
}
