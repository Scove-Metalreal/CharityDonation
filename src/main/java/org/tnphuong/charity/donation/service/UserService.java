package org.tnphuong.charity.donation.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.tnphuong.charity.donation.dto.UserDTO;
import org.tnphuong.charity.donation.entity.User;
import java.util.List;
import java.util.Optional;

public interface UserService {
    List<User> getAllUsers();
    Page<User> getAllUsers(Pageable pageable);
    Optional<User> getUserById(Integer id);
    User saveUser(User user);
    void deleteUser(Integer id);
    Optional<User> getUserByEmail(String email);
    Optional<User> getUserByPhoneNumber(String phoneNumber);
    List<User> searchUsers(String keyword);
    Page<User> searchUsers(String keyword, Integer roleId, Integer status, java.time.LocalDateTime inactiveSince, Pageable pageable);
    long countUsers();

    UserDTO convertToDTO(User user);
}
