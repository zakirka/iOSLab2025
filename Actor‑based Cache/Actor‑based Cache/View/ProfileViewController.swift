//
//  ProfileViewController.swift
//  Actor‑based Cache
//
//  Created by Azamat Zakirov on 19.04.2026.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    private let userService: UsersServiceProtocol

    let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(userService: UsersServiceProtocol) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupContraints()
        loadUserData()
    }

    private func setupViews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(followButton)
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
    }

    private func loadUserData() {
        Task {
            do {
                let users = try await userService.fetchUsers()
                await MainActor.run {
                    if users.isEmpty {
                        self.nameLabel.text = "Пользователи не найдены"
                        self.emailLabel.text = "---"
                        self.avatarImageView.image = nil
                    } else if let firstUser = users.first {
                        self.configure(with: firstUser)
                    }
                }
            } catch {
                print("Ошибка загрузки: \(error)")
            }
        }
    }

    func configure(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        let avatarUrlString = "https://starsaboutwar.in.ua/images/ZA/macan/macan-o-voine.jpg"
        if let url = URL(string: avatarUrlString) {
            avatarImageView.kf.setImage(with: url)
        }
    }

    @objc
    func followButtonTapped() {
        print("нажали на кнопку")
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20 ),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            followButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            followButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            followButton.widthAnchor.constraint(equalToConstant: 150),
            followButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}
