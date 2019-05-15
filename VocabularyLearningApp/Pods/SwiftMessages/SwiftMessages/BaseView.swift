
//
//  BaseView.swift
//  SwiftMessages
//
//  Created by Timothy Moose on 8/17/16.
//  Copyright © 2016 SwiftKick Mobile LLC. All rights reserved.
//

import UIKit

/**
 The `BaseView` class is a reusable message view base class that implements some
 of the optional SwiftMessages protocols and provides some convenience functions
 and a configurable tap handler. Message views do not need to inherit from `BaseVew`.
 */
open class BaseView: UIView, BackgroundViewable, MarginAdjustable {

    /*
     MARK: - IB outlets
     */

    /**
     Fulfills the `BackgroundViewable` protocol and is the target for
     the optional `tapHandler` block. Defaults to `self`.
     */
    @IBOutlet open weak var backgroundView: UIView! {
        didSet {
            if let old = oldValue {
                old.removeGestureRecognizer(tapRecognizer)
            }
            installTapRecognizer()
            updateBackgroundHeightConstraint()
        }
    }

    // The `contentView` property was removed because it no longer had any functionality
    // in the framework. This is a minor backwards incompatible change. If you've copied
    // one of the included nib files from a previous release, you may get a key-value
    // coding runtime error related to contentView, in which case you can subclass the
    // view and add a `contentView` property or you can remove the outlet connection in
    // Interface Builder.
    // @IBOutlet public var contentView: UIView!

    /*
     MARK: - Initialization
     */

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundView = self
        layoutMargins = UIEdgeInsets.zero
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = self
        layoutMargins = UIEdgeInsets.zero
    }

    /*
     MARK: - Installing background and content
     */

    /**
     A convenience function for installing a content view as a subview of `backgroundView`
     and pinning the edges to `backgroundView` with the specified `insets`.

     - Parameter contentView: The view to be installed into the background view
       and assigned to the `contentView` property.
     - Parameter insets: The amount to inset the content view from the background view.
       Default is zero inset.
     */
    open func installContentView(_ contentView: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: insets.top).isActive = true
        contentView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -insets.bottom).isActive = true
        contentView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: insets.left).isActive = true
        contentView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -insets.right).isActive = true
    }

    /**
     A convenience function for installing a background view and pinning to the layout margins.
     This is useful for creating programatic layouts where the background view needs to be
     inset from the message view's edges (like a card-style layout).

     - Parameter backgroundView: The view to be installed as a subview and
       assigned to the `backgroundView` property.
     - Parameter insets: The amount to inset the content view from the margins. Default is zero inset.
     */
    open func installBackgroundView(_ backgroundView: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        if backgroundView != self {
            backgroundView.removeFromSuperview()
        }
        addSubview(backgroundView)
        self.backgroundView = backgroundView
        backgroundView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: insets.top).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -insets.bottom).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: insets.left).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor, constant: -insets.right).isActive = true
        installTapRecognizer()
    }

    /**
     A convenience function for installing a background view and pinning to the horizontal
     layout margins and to the vertical edges. This is useful for creating programatic layouts where
     the background view needs to be inset from the message view's horizontal edges (like a tab-style layout).

     - Parameter backgroundView: The view to be installed as a subview and
       assigned to the `backgroundView` property.
     - Parameter insets: The amount to inset the content view from the horizontal margins and vertical edges.
       Default is zero inset.
     */
    open func installBackgroundVerticalView(_ backgroundView: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        if backgroundView != self {
            backgroundView.removeFromSuperview()
        }
        addSubview(backgroundView)
        self.backgroundView = backgroundView
        backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: insets.left).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor, constant: -insets.right).isActive = true
        installTapRecognizer()
    }

    /*
     MARK: - Tap handler
     */

    /**
     An optional tap handler that will be called when the `backgroundView` is tapped.
     */
    open var tapHandler: ((_ view: BaseView) -> Void)? {
        didSet {
            installTapRecognizer()
        }
    }

    fileprivate lazy var tapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageView.tapped))
        return tapRecognizer
    }()

    @objc func tapped() {
        tapHandler?(self)
    }

    fileprivate func installTapRecognizer() {
        guard let backgroundView = backgroundView else { return }
        removeGestureRecognizer(tapRecognizer)
        backgroundView.removeGestureRecognizer(tapRecognizer)
        if tapHandler != nil {
            // Only install the tap recognizer if there is a tap handler,
            // which makes it slightly nicer if one wants to install
            // a custom gesture recognizer.
            backgroundView.addGestureRecognizer(tapRecognizer)
        }
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if backgroundView != self {
            let backgroundViewPoint = convert(point, to: backgroundView)
            return backgroundView.point(inside: backgroundViewPoint, with: event)
        }
        return super.point(inside: point, with: event)
    }

    /*
     MARK: - MarginAdjustable

     These properties fulfill the `MarginAdjustable` protocol and are exposed
     as `@IBInspectables` so that they can be adjusted directly in nib files
     (see MessageView.nib).
     */

    public var layoutMarginAdditions: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: topLayoutMarginAddition, left: leftLayoutMarginAddition, bottom: bottomLayoutMarginAddition, right: rightLayoutMarginAddition)
        }
        set {
            topLayoutMarginAddition = newValue.top
            leftLayoutMarginAddition = newValue.left
            bottomLayoutMarginAddition = newValue.bottom
            rightLayoutMarginAddition = newValue.right
        }
    }

    /// IBInspectable access to layoutMarginAdditions.top
    @IBInspectable open var topLayoutMarginAddition: CGFloat = 0

    /// IBInspectable access to layoutMarginAdditions.left
    @IBInspectable open var leftLayoutMarginAddition: CGFloat = 0

    /// IBInspectable access to layoutMarginAdditions.bottom
    @IBInspectable open var bottomLayoutMarginAddition: CGFloat = 0

    /// IBInspectable access to layoutMarginAdditions.right
    @IBInspectable open var rightLayoutMarginAddition: CGFloat = 0

    @IBInspectable open var collapseLayoutMarginAdditions: Bool = true

    @IBInspectable open var bounceAnimationOffset: CGFloat = 5
     
    /// Deprecated
    @objc open var statusBarOffset: CGFloat = 0
    
    /// Deprecated
    @objc  open var safeAreaTopOffset: CGFloat = 0

    /// Deprecated
    @objc  open var safeAreaBottomOffset: CGFloat = 0

    /*
     MARK: - Setting the height
     */

    /**
     An optional explicit height for the background view, which can be used if
     the message view's intrinsic content size does not produce the desired height.
     */
    open var backgroundHeight: CGFloat? {
        didSet {
            updateBackgroundHeightConstraint()
        }
    }

    private func updateBackgroundHeightConstraint() {
        if let existing = backgroundHeightConstraint {
            let view = existing.firstItem as! UIView
            view.removeConstraint(existing)
            backgroundHeightConstraint = nil
        }
        if let height = backgroundHeight {
            let constraint = NSLayoutConstraint(item: backgroundView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
            backgroundView.addConstraint(constraint)
            backgroundHeightConstraint = constraint
        }
    }

    private var backgroundHeightConstraint: NSLayoutConstraint?

    open override var intrinsicContentSize: CGSize {
        if let preferredHeight = (self as InternalPreferredHeight).preferredHeight {
            return CGSize(width: UIView.noIntrinsicMetric, height: preferredHeight)
        }
        return super.intrinsicContentSize
    }

    /**
     An optional value that sets the message view's intrinsic content height.
     This can be used as a way to specify a fixed height for the message view.
     Note that this height is not guaranteed depending on anyt Auto Layout
     constraints used within the message view.
     */
    @available(*, deprecated, message:"Use `backgroundHeight` instead to specify preferred height of the visible region of the message.")
    open var preferredHeight: CGFloat? {
        didSet {
            setNeedsLayout()
        }
    }
}

// A workaround to prevent warning on deprecated property.
private protocol InternalPreferredHeight {
    var preferredHeight: CGFloat? { get }
}
extension BaseView: InternalPreferredHeight {}

/*
 MARK: - Theming
 */

extension BaseView {

    /// A convenience function to configure a default drop shadow effect.
    /// The shadow is to this view's layer instead of that of the background view
    /// because the background view may be masked. So, when modifying the drop shadow,
    /// be sure to set the shadow properties of this view's layer. The shadow path is
    /// updated for you automatically.
    open func configureDropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        updateShadowPath()
    }

    /// A convenience function to turn off drop shadow
    open func configureNoDropShadow() {
        layer.shadowOpacity = 0
    }

    private func updateShadowPath() {
        backgroundView?.layoutIfNeeded()
        let shadowLayer = backgroundView?.layer ?? layer
        let shadowRect = layer.convert(shadowLayer.bounds, from: shadowLayer)
        let shadowPath: CGPath?
        if let backgroundMaskLayer = shadowLayer.mask as? CAShapeLayer,
            let backgroundMaskPath = backgroundMaskLayer.path {
            var transform = CGAffineTransform(translationX: shadowRect.minX, y: shadowRect.minY)
            shadowPath = backgroundMaskPath.copy(using: &transform)
        } else {
            shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: shadowLayer.cornerRadius).cgPath
        }
        // This is a workaround needed for smooth rotation animations.
        if let foundAnimation = layer.findAnimation(forKeyPath: "bounds.size") {
            // Update the layer's `shadowPath` with animation, copying the relevant properties
            // from the found animation.
            let animation = CABasicAnimation(keyPath: "shadowPath")
            animation.duration = foundAnimation.duration
            animation.timingFunction = foundAnimation.timingFunction
            animation.fromValue = layer.shadowPath
            animation.toValue = shadowPath
            layer.add(animation, forKey: "shadowPath")
            layer.shadowPath = shadowPath
        } else {
            // Update the layer's `shadowPath` without animation
            layer.shadowPath = shadowPath        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }
}
    
