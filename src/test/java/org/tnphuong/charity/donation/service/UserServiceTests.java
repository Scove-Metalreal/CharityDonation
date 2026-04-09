package org.tnphuong.charity.donation.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.tnphuong.charity.donation.dao.UserRepository;
import org.tnphuong.charity.donation.entity.Role;
import org.tnphuong.charity.donation.entity.User;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class UserServiceTests {

    @Mock
    private UserRepository userRepository;

    @Mock
    private RoleService roleService;

    @InjectMocks
    private UserServiceImpl userService;

    private User testUser;

    @BeforeEach
    void setUp() {
        testUser = new User();
        testUser.setEmail("test@example.com");
        testUser.setFullName("Test User");
        testUser.setPhoneNumber("0987654321");
    }

    @Test
    void testSaveUser_PasswordTooShort_ThrowsException() {
        testUser.setPassword("123"); // Too short (< 6)

        Exception exception = assertThrows(RuntimeException.class, () -> {
            userService.saveUser(testUser);
        });

        assertEquals("Mật khẩu phải từ 6 đến 100 ký tự.", exception.getMessage());
        verify(userRepository, never()).saveAndFlush(any());
    }

    @Test
    void testGetOrCreateGuest_NewGuest_Success() {
        String email = "guest@test.com";
        String phone = "0123456789";
        
        when(userRepository.findByPhoneNumber(phone)).thenReturn(Optional.empty());
        when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
        when(roleService.getRoleByName("GUEST")).thenReturn(Optional.of(new Role()));
        when(userRepository.saveAndFlush(any(User.class))).thenAnswer(i -> i.getArguments()[0]);

        User guest = userService.getOrCreateGuest(email, phone, "Guest User", "Hanoi");

        assertNotNull(guest);
        assertEquals(email, guest.getEmail());
        verify(userRepository, times(1)).saveAndFlush(any(User.class));
    }

    @Test
    void testGetOrCreateGuest_InvalidEmail_ThrowsException() {
        String invalidEmail = "invalid-email";
        
        Exception exception = assertThrows(RuntimeException.class, () -> {
            userService.getOrCreateGuest(invalidEmail, "0123456789", "Guest", "");
        });

        assertEquals("Định dạng email không hợp lệ.", exception.getMessage());
    }

    @Test
    void testGetOrCreateGuest_ExistingMemberEmail_ThrowsException() {
        String email = "member@test.com";
        User existingMember = new User();
        Role userRole = new Role();
        userRole.setRoleName("USER");
        existingMember.setRole(userRole);
        existingMember.setEmail(email);

        when(userRepository.findByPhoneNumber(any())).thenReturn(Optional.empty());
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(existingMember));

        Exception exception = assertThrows(RuntimeException.class, () -> {
            userService.getOrCreateGuest(email, "0123456789", "Guest", "");
        });

        assertEquals("Email này đã có tài khoản thành viên. Vui lòng đăng nhập.", exception.getMessage());
    }
}
