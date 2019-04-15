//
//  MembersCollectionViewController.swift
//  Twitebo
//
//  Created by Tobias Scholze on 12.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

// MARK: - MembersCollectionViewControllerDelegate -

/// `MembersCollectionViewControllerDelegate` can be adopted by an object to get notified on changes in `MembersCollectionViewController`.
protocol MembersCollectionViewControllerDelegate: AnyObject
{
    /// Teels the delegate that a member has been selected within a
    /// `MembersCollectionViewController`.
    ///
    /// - Parameter member: Selected member.
    func membersCollectionViewControllerDidSelectMember(_ member: Member)
}

// MARK: - MembersCollectionViewController -

/// `MembersCollectionViewController` is responsable for presenting a
/// scrollable list of team members.
class MembersCollectionViewController: UICollectionViewController
{
    // MARK: - Static internal properties -

    /// Collection view item width.
    static var itemWidth = 200

    /// Collection view item height.
    static var itemHeight = 200

    // Collection view item intertem spacing.
    static var itemSpacing: CGFloat = 20

    // MARK: - Internal properties -

    /// Controller's delegate.
    weak var delegate: MembersCollectionViewControllerDelegate?

    // MARK: - Private properties -

    // Underlying team which members will be shown.
    private var team: Team?

    // MARK: - View life cycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Apply styling.
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 20,
                                                   bottom: 0,
                                                   right: 20)
    }

    // MARK: - Internal helper -

    /// Sets up the view for given team's members.
    ///
    /// - Parameter team: Underlying team.
    func setup(forTeam team: Team?)
    {
        self.team = team
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -

extension MembersCollectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize
    {
        return CGSize(width: MembersCollectionViewController.itemWidth,
                      height: MembersCollectionViewController.itemHeight + 4)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat
    {
        return MembersCollectionViewController.itemSpacing
    }
}

// MARK: - UICollectionViewDataSource -

extension MembersCollectionViewController
{
    override func numberOfSections(in _: UICollectionView) -> Int
    {
        return 1
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int
    {
        return team?.members.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCell.identifier, for: indexPath) as? MemberCell, let team = team else
        {
            fatalError("Could not find cell `\(MemberCell.identifier)` or team is not.")
        }

        cell.setup(for: team.members[indexPath.item])

        return cell
    }
}

// MARK: - UICollectionViewDelegate -

extension MembersCollectionViewController
{
    override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // Ensure that member is available.
        guard let member = team?.members[indexPath.item] else
        {
            print("No member found.")
            return
        }

        // Call delegate.
        delegate?.membersCollectionViewControllerDidSelectMember(member)
    }
}
