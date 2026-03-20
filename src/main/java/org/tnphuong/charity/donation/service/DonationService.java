package org.tnphuong.charity.donation.service;

import org.tnphuong.charity.donation.entity.Donation;
import java.util.List;
import java.util.Optional;

public interface DonationService {
    List<Donation> getAllDonations();
    Optional<Donation> getDonationById(Integer id);
    Donation saveDonation(Donation donation);
    List<Donation> getDonationsByCampaignId(Integer campaignId);
    List<Donation> getDonationsByUserId(Integer userId);
    
    void confirmDonation(Integer donationId);
    void rejectDonation(Integer donationId);
    
    List<Donation> getConfirmedDonationsByCampaignId(Integer campaignId);
}
