package org.tnphuong.charity.donation.service;

import org.tnphuong.charity.donation.entity.User;
import java.util.List;
import java.util.Optional;

public interface UserService {
    List<User> getAllUsers();
    Optional<User> getUserById(Integer id);
    User saveUser(User user);
    void deleteUser(Integer id);
    Optional<User> getUserByEmail(String email);
    List<User> searchUsers(String keyword);
}
