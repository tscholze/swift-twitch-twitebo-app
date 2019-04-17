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
    /// - Parameters
    ///     - membersCollectionViewController: Collection view that called the delegate.
    ///     - member: Selected member.
    func membersCollectionViewControllerDidSelectMember(_ membersCollectionViewController: MembersCollectionViewController, member: Member)
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

    // Underlying members will be shown.
    private var members = [Member]()

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
    /// - Parameters
    ///     - team: Underlying team.
    ///     - showOnlyOnlineMembers: Determins if only online
    ///                             members should be shown.
    func setup(forTeam team: Team?, showOnlyOnlineMembers: Bool = false)
    {
        // Sort team members by display name.
        members = team?.members.sorted(by: { $0.displayName < $1.displayName }) ?? []

        // Filter only online members if flag is set to true.
        if showOnlyOnlineMembers
        {
            members = members.filter { $0.isOnline == true }
        }

        // Call collection view to reload itself.
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
        return members.isEmpty ? 1 : members.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // Check if members is empty.
        //  - yes: Show empty member placeholder cell.
        //  - no: Show member cells.
        if members.isEmpty
        {
            return collectionView.dequeueReusableCell(withReuseIdentifier: NoMemberOnlineCell.identifier,
                                                      for: indexPath)
        }
        else
        {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCell.identifier, for: indexPath) as? MemberCell else
            {
                fatalError("Could not find cell `\(MemberCell.identifier)`.")
            }

            cell.setup(for: members[indexPath.item])

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate -

extension MembersCollectionViewController
{
    override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // Ensure that the team is not empty and the user did not tap on a no-member-cell.
        guard members.isEmpty == false else { return }

        // Call delegate.
        delegate?.membersCollectionViewControllerDidSelectMember(self, member: members[indexPath.item])
    }
}
