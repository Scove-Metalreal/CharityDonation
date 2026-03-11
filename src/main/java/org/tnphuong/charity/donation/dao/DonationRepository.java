package org.tnphuong.charity.donation.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.tnphuong.charity.donation.entity.Donation;
import java.util.List;

public interface DonationRepository extends JpaRepository<Donation, Integer> {
    List<Donation> findByCampaignId(Integer campaignId);
    List<Donation> findByUserId(Integer userId);
}
