package org.tnphuong.charity.donation.utils;

import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PasswordUtils {
    private static final Logger logger = LoggerFactory.getLogger(PasswordUtils.class);

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
            logger.error("Password format error: {}", e.getMessage());
            return false;
        }
    }
}
