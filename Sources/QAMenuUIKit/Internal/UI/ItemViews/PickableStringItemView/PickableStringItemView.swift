//
//  PickableStringItemView.swift
//
//  Created by Hans Seiffert on 13.12.20.
//
//  ---
//  MIT License
//
//  Copyright © 2020 Hans Seiffert
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//

import Foundation
import UIKit
import QAMenu
import QAMenuUtils

internal final class PickableStringItemView: NibView, ItemView, ShareInteractionSupporting {

    // MARK: - Properties (Internal)

    internal weak var delegate: ItemUIRepresentableDelegate?

    internal var shareInteractionHandler: ShareInteractionHandling?

    internal var footerText: Dynamic<String?>? {
        return item?.footerText
    }

    internal var footerContainer: UIStackView {
        return self.stackView
    }

    // MARK: - Properties (Private)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkboxView: CheckboxView!
    @IBOutlet private weak var stackView: UIStackView!

    private let disposeBag = DisposeBag()

    private weak var item: PickableStringItem? {
        didSet {
            self.disposeBag.dispose()
            self.item?.onInvalidation
                .observe { [weak self] in
                    self?.reload()
                }
                .disposeWith(self.disposeBag)
            self.shareInteractionHandler?.shareable = self.item
            self.updateViewContent()
        }
    }

    // MARK: - Lifecycle

    override internal func initFromNib() {
        super.initFromNib()
        self.titleLabel.numberOfLines = 0
        self.setupFooterView()

        self.shareInteractionHandler = ShareInteractionHandler(
            shareable: nil,
            view: self,
            present: { [weak self] present in
                guard let presentationContext = self?.delegate?.presentationContext else {
                    return
                }
                present(presentationContext)
            }
        )
    }

    internal func prepareForReuse() {
        self.item = nil
    }

    internal func setItem(_ item: Item) {
        guard let stringItem = item as? PickableStringItem else {
            Logger.error("\(Self.self) expected to receive a PickableStringItem, but \(item) was passed")
            return
        }
        self.item = stringItem
    }

    // MARK: - Methods (Private)

    private func updateViewContent() {
        if let item = item {
            self.titleLabel.text = item.title()
        } else {
            self.titleLabel.text = nil
        }
        self.checkboxView.isHidden = !(item?.isSelected() ?? false)

        updateFooterView()
    }

    private func reload() {
        self.updateViewContent()
        self.delegate?.updateContainerHeight(for: self)
    }
}
