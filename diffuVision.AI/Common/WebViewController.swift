//
//  WebViewController.swift
//  diffuVision.AI
//
//  Created by İhsan Akbay on 6.07.2023.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
	private lazy var webView: WKWebView = {
		let preferences = WKWebpagePreferences()
		preferences.allowsContentJavaScript = true
		let configuration = WKWebViewConfiguration()
		configuration.defaultWebpagePreferences = preferences
		let webView = WKWebView(frame: .zero, configuration: configuration)
		return webView
	}()
	
	private let url: URL
	
	init(url: URL, title: String) {
		self.url = url
		super.init(nibName: nil, bundle: nil)
		self.title = title
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(webView)
		webView.load(URLRequest(url: url))
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		webView.frame = view.bounds
	}
}
