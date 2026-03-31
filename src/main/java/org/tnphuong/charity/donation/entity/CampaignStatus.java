package org.tnphuong.charity.donation.entity;

public enum CampaignStatus {
    NEW(0),
    IN_PROGRESS(1),
    COMPLETED(2),
    CLOSED(3);

    private final int value;

    CampaignStatus(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public static CampaignStatus fromInt(int value) {
        for (CampaignStatus status : CampaignStatus.values()) {
            if (status.value == value) {
                return status;
            }
        }
        return NEW;
    }
}
