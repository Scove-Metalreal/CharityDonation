package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.tnphuong.charity.donation.dao.UserRepository;
import org.tnphuong.charity.donation.dao.DonationRepository;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.utils.PasswordUtils;

import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DonationRepository donationRepository;

    @Autowired
    private CampaignService campaignService;

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
            String pwd = user.getPassword();
            if (pwd == null || pwd.isEmpty()) {
                user.setPassword(PasswordUtils.hashPassword("123456"));
            } else if (!pwd.startsWith("$2a$")) {
                user.setPassword(PasswordUtils.hashPassword(pwd));
            }
            
            if (user.getCreatedAt() == null) {
                user.setCreatedAt(java.time.LocalDateTime.now());
            }
            if (user.getStatus() == null) {
                user.setStatus(1); // Default Active
            }
        } else {
            // Update user: only hash if password was changed
            String pwd = user.getPassword();
            if (pwd != null && !pwd.isEmpty() && !pwd.startsWith("$2a$")) {
                user.setPassword(PasswordUtils.hashPassword(pwd));
            }
        }
        return userRepository.save(user);
    }

    @Override
    @Transactional
    public void deleteUser(Integer id) {
        // Lấy danh sách quyên góp của user này để trừ tiền campaign nếu đã được confirm
        List<Donation> donations = donationRepository.findByUserId(id);
        for (Donation d : donations) {
            if (d.getStatus() == 1) { // 1 = STATUS_CONFIRMED
                campaignService.subtractCurrentMoney(d.getCampaign().getId(), d.getAmount());
            }
        }
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

    @Override
    public long countUsers() {
        return userRepository.count();
    }
}
