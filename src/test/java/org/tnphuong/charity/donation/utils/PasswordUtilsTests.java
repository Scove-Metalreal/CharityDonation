package org.tnphuong.charity.donation.utils;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class PasswordUtilsTests {

    @Test
    void testHashAndCheckPassword_Success() {
        String rawPassword = "mySecurePassword123";
        
        // Hash password
        String hashedPassword = PasswordUtils.hashPassword(rawPassword);
        
        assertNotNull(hashedPassword);
        assertNotEquals(rawPassword, hashedPassword);
        assertTrue(hashedPassword.startsWith("$2")); // BCrypt prefix
        
        // Check password
        assertTrue(PasswordUtils.checkPassword(rawPassword, hashedPassword));
    }

    @Test
    void testCheckPassword_Fail() {
        String rawPassword = "correctPassword";
        String wrongPassword = "wrongPassword";
        String hashedPassword = PasswordUtils.hashPassword(rawPassword);
        
        assertFalse(PasswordUtils.checkPassword(wrongPassword, hashedPassword));
    }

    @Test
    void testHashPassword_DifferentEveryTime() {
        String password = "samePassword";
        String hash1 = PasswordUtils.hashPassword(password);
        String hash2 = PasswordUtils.hashPassword(password);
        
        assertNotEquals(hash1, hash2); // BCrypt uses random salt
        assertTrue(PasswordUtils.checkPassword(password, hash1));
        assertTrue(PasswordUtils.checkPassword(password, hash2));
    }

    @Test
    void testHashAndCheck_EmptyPassword_Success() {
        String emptyPassword = "";
        String hash = PasswordUtils.hashPassword(emptyPassword);
        assertNotNull(hash);
        assertTrue(PasswordUtils.checkPassword(emptyPassword, hash));
    }

    @Test
    void testCheckPassword_NullValues_ReturnsFalse() {
        assertFalse(PasswordUtils.checkPassword(null, "$2a$10$abcdefghij"));
        assertFalse(PasswordUtils.checkPassword("password", null));
    }

    @Test
    void testCheckPassword_InvalidHashFormat_ReturnsFalse() {
        // Một chuỗi không phải định dạng BCrypt
        String invalidHash = "not-a-bcrypt-hash";
        assertFalse(PasswordUtils.checkPassword("password", invalidHash));
    }
}
