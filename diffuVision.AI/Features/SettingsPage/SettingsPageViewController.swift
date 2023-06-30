//
//  SettingsPageViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 29.06.2023.
//

import UIKit

private typealias DataSource = UITableViewDiffableDataSource<SettingsPageViewController.Section, SettingsModel>
private typealias DataSnapshot = NSDiffableDataSourceSnapshot<SettingsPageViewController.Section, SettingsModel>

class SettingsPageViewController: UIViewController {
	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	private lazy var dataSource: DataSource = .init(tableView: tableView) { tableView, indexPath, item in
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseId, for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
		cell.configure(model: item)
		return cell
	}

	private let viewModel: SettingsPageViewModel = .init()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = LocaleStrings.tabSettings
		setupLayout()
		applySnapshot()
		viewModel.output = self
	}

	private func setupLayout() {
		view.backgroundColor = Colors.backgroundColor.color
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.backgroundColor = .clear
		tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseId)
		tableView.snp.makeConstraints { make in
			make.leading.trailing.top.bottom.equalToSuperview()
		}
	}

	private func applySnapshot() {
		var snapshot = DataSnapshot()
		snapshot.appendSections([.user, .app, .auth])
		snapshot.appendItems(SettingsModel.userModels, toSection: .user)
		snapshot.appendItems(SettingsModel.appModels, toSection: .app)
		snapshot.appendItems(SettingsModel.authModels, toSection: .auth)
		dataSource.apply(snapshot, animatingDifferences: true)
	}
}

private extension SettingsPageViewController {
	enum Section {
		case user
		case app
		case auth
	}
}

extension SettingsPageViewController: SettingsPageViewOutput {
	func signOut() {}

	func deleteAccount() {}
}

extension SettingsPageViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
