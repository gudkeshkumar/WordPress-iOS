import UIKit
import SwiftUI
import WordPressUI

final class CompliancePopoverViewController: UIViewController {

    // MARK: - Dependencies

    private let viewModel: CompliancePopoverViewModel

    // MARK: - Views

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let hostingController: UIHostingController<CompliancePopover>

    private var contentView: UIView {
        return hostingController.view
    }

    // MARK: - Init

    init(viewModel: CompliancePopoverViewModel) {
        self.viewModel = viewModel
        let content = CompliancePopover(viewModel: viewModel)
        self.hostingController = UIHostingController(rootView: content)
        super.init(nibName: nil, bundle: nil)
    }

    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addContentView()
        self.viewModel.didDisplayPopover()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Calculate the size needed for the view to fit its content
        let targetSize = CGSize(width: view.bounds.width, height: 0)
        self.contentView.frame = CGRect(origin: .zero, size: targetSize)
        let contentViewSize = contentView.systemLayoutSizeFitting(targetSize)
        self.contentView.frame.size = contentViewSize

        // Set the scrollView's content size to match the contentView's size
        //
        // Scroll is enabled / disabled automatically depending on whether the `contentSize` is bigger than the its size.
        self.scrollView.contentSize = contentViewSize

        // Set the preferred content size for the view controller to match the contentView's size
        //
        // This property should be updated when `DrawerPresentable.collapsedHeight` is `intrinsicHeight`.
        // Because under the hood the `BottomSheetViewController` reads this property to layout its subviews.
        self.preferredContentSize = contentViewSize
    }

    private func addContentView() {
        self.view.addSubview(scrollView)
        self.view.pinSubviewToAllEdges(scrollView)
        self.hostingController.willMove(toParent: self)
        self.addChild(hostingController)
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        self.scrollView.addSubview(contentView)
        self.hostingController.didMove(toParent: self)
    }
}

// MARK: - DrawerPresentable

extension CompliancePopoverViewController: DrawerPresentable {
    var collapsedHeight: DrawerHeight {
        if traitCollection.verticalSizeClass == .compact {
            return .maxHeight
        }
        return .intrinsicHeight
    }

    var allowsUserTransition: Bool {
        return false
    }

    var allowsDragToDismiss: Bool {
        false
    }

    var allowsTapToDismiss: Bool {
        return false
    }
}
