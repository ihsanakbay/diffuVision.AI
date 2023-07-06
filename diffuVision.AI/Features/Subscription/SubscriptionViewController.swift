//
//  SubscriptionViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 3.07.2023.
//

import Combine
import StoreKit
import UIKit

private typealias DataSource = UITableViewDiffableDataSource<SubscriptionViewController.Section, Product>
private typealias DataSnapshot = NSDiffableDataSourceSnapshot<SubscriptionViewController.Section, Product>

class SubscriptionViewController: UIViewController {
	private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)

	private let descriptionLabel: UILabel = LabelFactory.build(
		text: LocaleStrings.subscriptionsDescription,
		font: UIFont.systemFont(ofSize: 16),
		textColor: Colors.textColor.color,
		textAlignment: .center)

	private let currentSubscription: UILabel = LabelFactory.build(
		text: "",
		font: UIFont.systemFont(ofSize: 14),
		textColor: Colors.textColor.color.withAlphaComponent(0.75),
		textAlignment: .center)

	private lazy var restoreButton: UIButton = {
		let button = UIButton()
		button.configuration = .plain()
		button.configuration?.title = LocaleStrings.restore
		button.configuration?.baseForegroundColor = Colors.textColor.color.withAlphaComponent(0.8)
		button.addTarget(self, action: #selector(restorePurchase), for: .touchUpInside)
		return button
	}()

	private let subscriptionToCLabel = LabelFactory.build(
		text: LocaleStrings.subscriptionToC,
		font: UIFont.systemFont(ofSize: 12, weight: .light),
		textColor: Colors.textColor.color.withAlphaComponent(0.7),
		textAlignment: .center)

	private let viewModel: SubscriptionViewModel = .init()
	private let output = PassthroughSubject<SubscriptionViewModel.Input, Never>()
	private var cancellables = Set<AnyCancellable>()

	private lazy var dataSource: DataSource = .init(tableView: tableView) { tableView, indexPath, item in
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionTableViewCell.reuseId,
		                                               for: indexPath) as? SubscriptionTableViewCell else { return UITableViewCell() }
		Task {
			if await self.viewModel.checkIsPurchased(product: item) ?? false {
				cell.backgroundColor = Colors.accentColor2.color.withAlphaComponent(0.2)
				cell.isUserInteractionEnabled = false
			}
		}
		cell.configure(model: item)
		return cell
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = LocaleStrings.allPlans
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: LocaleStrings.doneButton, style: .done, target: self, action: #selector(dismissView))
		setupLayout()
		observe()
		output.send(.viewDidLoad)
		applySnapshot()
	}

	private func setupLayout() {
		view.backgroundColor = Colors.backgroundColor.color
		view.addSubview(descriptionLabel)
		view.addSubview(currentSubscription)
		view.addSubview(tableView)
		view.addSubview(restoreButton)
		view.addSubview(subscriptionToCLabel)

		descriptionLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.bottom.equalTo(currentSubscription.snp.top).offset(-20)
		}

		currentSubscription.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalToSuperview().offset(-20)
			make.bottom.equalTo(tableView.snp.top).offset(-8)
		}

		tableView.delegate = self
		tableView.backgroundColor = .clear
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.register(SubscriptionTableViewCell.self, forCellReuseIdentifier: SubscriptionTableViewCell.reuseId)
		tableView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
		}

		restoreButton.snp.makeConstraints { make in
			make.top.equalTo(tableView.snp.bottom).offset(20)
			make.leading.equalTo(tableView.snp.leading)
			make.trailing.equalTo(tableView.snp.trailing)
			make.bottom.equalTo(subscriptionToCLabel.snp.top).offset(-20)
			make.height.equalTo(42)
		}

		subscriptionToCLabel.snp.makeConstraints { make in
			make.leading.equalTo(tableView.snp.leading).offset(16)
			make.trailing.equalTo(tableView.snp.trailing).offset(-16)
			make.bottom.equalTo(view.snp.bottom).offset(-40)
		}
	}

	private func observe() {
		viewModel.transform(input: output.eraseToAnyPublisher())
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				switch event {
				case .subscriptionsFetched:
					self?.applySnapshot()
				case .currentSubscriptionsFetched:
					if let plan = self?.viewModel.currentSubscription {
						self?.currentSubscription.text = LocaleStrings.yourSubs(plan.displayName)
					} else {
						self?.currentSubscription.text = LocaleStrings.noSubs
					}
				case .purchaseSuccessfull:
					if let plan = self?.viewModel.currentSubscription {
						self?.currentSubscription.text = LocaleStrings.yourSubs(plan.displayName)
					}
					self?.dismissView()
				case .errorOccured(error: let error):
					self?.infoAlert(message: error.localizedDescription, title: LocaleStrings.error)
				}
			}
			.store(in: &cancellables)
	}

	private func applySnapshot() {
		var snapshot = DataSnapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(viewModel.items)
		dataSource.apply(snapshot, animatingDifferences: true)
	}

	@objc private func dismissView() {
		dismiss(animated: true)
		output.send(.viewDidLoad)
	}

	@objc private func restorePurchase() {
		output.send(.didRestoreTapped)
		dismissView()
	}
}

extension SubscriptionViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if let selected = dataSource.itemIdentifier(for: indexPath) {
			output.send(.didBuyTapped(product: selected))
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
	}
}

private extension SubscriptionViewController {
	enum Section {
		case main
	}
}
