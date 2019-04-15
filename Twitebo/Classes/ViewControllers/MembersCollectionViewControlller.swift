//
//  MembersCollectionViewControlller.swift
//  Twitebo
//
//  Created by Tobias Scholze on 12.04.19.
//  Copyright © 2019 Tobias Scholze. All rights reserved.
//

import UIKit

/// `MembersCollectionViewControlller` is responsable for presenting a
/// scrollable list of team members.
class MembersCollectionViewControlller: UICollectionViewController
{
    // MARK: - Internal properties -

    /// Collection view item width.
    static var itemWidth = 200

    /// Collection view item height.
    static var itemHeight = 200

    // Collection view item intertem spacing.
    static var itemSpacing: CGFloat = 5

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

extension MembersCollectionViewControlller: UICollectionViewDelegateFlowLayout
{
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize
    {
        return CGSize(width: MembersCollectionViewControlller.itemWidth,
                      height: MembersCollectionViewControlller.itemHeight + 4)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat
    {
        return MembersCollectionViewControlller.itemSpacing
    }
}

// MARK: - UICollectionViewDataSource -

extension MembersCollectionViewControlller
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

extension MembersCollectionViewControlller
{
    override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("Tapped on item: \(indexPath.item)")
    }
}
