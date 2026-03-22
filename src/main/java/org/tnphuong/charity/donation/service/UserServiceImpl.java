package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.tnphuong.charity.donation.dao.UserRepository;
import org.tnphuong.charity.donation.entity.User;
import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public Page<User> getAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Override
    public Optional<User> getUserById(Integer id) {
        return userRepository.findById(id);
    }

    @Override
    public User saveUser(User user) {
        if (user.getId() == null) {
            // New user: must have a password
            if (user.getPassword() == null || user.getPassword().isEmpty()) {
                user.setPassword(org.tnphuong.charity.donation.utils.PasswordUtils.hashPassword("123456"));
            } else {
                user.setPassword(org.tnphuong.charity.donation.utils.PasswordUtils.hashPassword(user.getPassword()));
            }
            if (user.getCreatedAt() == null) {
                user.setCreatedAt(java.time.LocalDateTime.now());
            }
            if (user.getStatus() == null) {
                user.setStatus(1); // Default Active
            }
        } else {
            // Update user: only hash if password was changed (handled in controller or here if password field is filled)
            // For now, assume if the password field in the entity is changed and not already hashed, we hash it.
            // A better way is to check if it's already a BCrypt hash.
            String pwd = user.getPassword();
            if (pwd != null && !pwd.isEmpty() && !pwd.startsWith("$2a$")) {
                user.setPassword(org.tnphuong.charity.donation.utils.PasswordUtils.hashPassword(pwd));
            }
        }
        return userRepository.save(user);
    }

    @Override
    public void deleteUser(Integer id) {
        userRepository.deleteById(id);
    }

    @Override
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public Optional<User> getUserByPhoneNumber(String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber);
    }

    @Override
    public List<User> searchUsers(String keyword) {
        return userRepository.searchUsers(keyword);
    }

    @Override
    public Page<User> searchUsers(String keyword, Integer roleId, Integer status, java.time.LocalDateTime inactiveSince, Pageable pageable) {
        return userRepository.searchUsers(keyword, roleId, status, inactiveSince, pageable);
    }
}
