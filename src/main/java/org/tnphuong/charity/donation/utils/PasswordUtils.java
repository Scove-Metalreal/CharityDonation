package org.tnphuong.charity.donation.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {
    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean checkPassword(String password, String hashedPassword) {
        try {
            if (hashedPassword == null || !hashedPassword.startsWith("$2a$") || hashedPassword.length() < 30) {
                return false;
            }
            return BCrypt.checkpw(password, hashedPassword);
        } catch (Exception e) {
            System.err.println("ERROR: Mat khau trong DB khong dung dinh dang BCrypt: " + e.getMessage());
            return false;
        }
    }
}
