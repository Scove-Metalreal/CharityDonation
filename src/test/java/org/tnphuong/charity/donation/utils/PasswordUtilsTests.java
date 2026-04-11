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
}
