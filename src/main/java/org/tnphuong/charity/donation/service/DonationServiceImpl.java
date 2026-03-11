package org.tnphuong.charity.donation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.tnphuong.charity.donation.dao.DonationRepository;
import org.tnphuong.charity.donation.entity.Donation;
import java.util.List;
import java.util.Optional;

@Service
public class DonationServiceImpl implements DonationService {

    @Autowired
    private DonationRepository donationRepository;

    @Override
    public List<Donation> getAllDonations() {
        return donationRepository.findAll();
    }

    @Override
    public Optional<Donation> getDonationById(Integer id) {
        return donationRepository.findById(id);
    }

    @Override
    public Donation saveDonation(Donation donation) {
        return donationRepository.save(donation);
    }

    @Override
    public List<Donation> getDonationsByCampaignId(Integer campaignId) {
        return donationRepository.findByCampaignId(campaignId);
    }

    @Override
    public List<Donation> getDonationsByUserId(Integer userId) {
        return donationRepository.findByUserId(userId);
    }
}
