package org.tnphuong.charity.donation.entity;

public enum UserStatus {
    LOCKED(0),
    ACTIVE(1);

    private final int value;

    UserStatus(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public static UserStatus fromInt(int value) {
        for (UserStatus status : UserStatus.values()) {
            if (status.value == value) {
                return status;
            }
        }
        return ACTIVE;
    }
}
