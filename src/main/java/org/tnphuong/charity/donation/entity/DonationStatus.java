package org.tnphuong.charity.donation.entity;

public enum DonationStatus {
    PENDING(0),
    CONFIRMED(1),
    REJECTED(2);

    private final int value;

    DonationStatus(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public static DonationStatus fromInt(int value) {
        for (DonationStatus status : DonationStatus.values()) {
            if (status.value == value) {
                return status;
            }
        }
        return PENDING;
    }
}
