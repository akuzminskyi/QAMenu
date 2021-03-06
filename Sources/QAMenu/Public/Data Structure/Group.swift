//
//  Group.swift
//
//  Created by Hans Seiffert on 31.12.20.
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

public protocol Group: Invalidatable, FooterSupport {

    // MARK: - Properties (Public)

    var onInvalidation: InvalidationEvent { get }

    // MARK: - Properties (Internal)

    var title: Dynamic<String?>? { get }
    var items: [Item] { get }

    func removeTitle()
}

// MARK: - Group + Conversions

extension Group {

    // MARK: Title is extracted from group

    public func asPane(
        isSearchable: Bool = false
    ) -> Pane {
        let groupTitle = self.title ?? .static("")
        self.removeTitle()
        return self.asPane(title: groupTitle, isSearchable: isSearchable)
    }

    public func asChildPaneItem(
        footerText: Dynamic<String?>? = nil,
        isSearchable: Bool = false
    ) -> ChildPaneItem {
        return self.asPane(isSearchable: isSearchable).asChildPaneItem(footerText: footerText)
    }

    // MARK: Title is received as parameter

    public func asPane(
        title: Dynamic<String?>,
        isSearchable: Bool = false
    ) -> Pane {
        return [self].asPane(title: title, isSearchable: isSearchable)
    }

    public func asChildPaneItem(
        title: Dynamic<String?>,
        footerText: Dynamic<String?>? = nil,
        isSearchable: Bool = false
    ) -> ChildPaneItem {
        return self.asPane(title: title, isSearchable: isSearchable).asChildPaneItem(footerText: footerText)
    }
}

// MARK: - Array<Group> + Conversions

extension Array where Element: Group {

    public func asPane(
        title: Dynamic<String?>,
        isSearchable: Bool = false
    ) -> Pane {
        return Pane(
            title: title,
            groups: self,
            isSearchable: isSearchable
        )
    }

    public func asChildPaneItem(
        title: Dynamic<String?>,
        footerText: Dynamic<String?>? = nil,
        isSearchable: Bool = false
    ) -> ChildPaneItem {
        let pane = self.asPane(
            title: title,
            isSearchable: isSearchable
        )
        return pane.asChildPaneItem(footerText: footerText)
    }
}
