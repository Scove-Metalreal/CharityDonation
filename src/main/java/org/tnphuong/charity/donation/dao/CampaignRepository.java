package org.tnphuong.charity.donation.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.tnphuong.charity.donation.entity.Campaign;
import java.util.Optional;

public interface CampaignRepository extends JpaRepository<Campaign, Integer> {
    Optional<Campaign> findByCode(String code);
}
