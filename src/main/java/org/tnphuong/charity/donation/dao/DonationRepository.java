package org.tnphuong.charity.donation.dao;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.tnphuong.charity.donation.entity.Donation;
import java.util.List;

public interface DonationRepository extends JpaRepository<Donation, Integer> {
    List<Donation> findByCampaignId(Integer campaignId);
    List<Donation> findByUserId(Integer userId);
    List<Donation> findByCampaignIdAndStatus(Integer campaignId, Integer status);

    @Query("SELECT d FROM Donation d WHERE d.campaign.id = :campaignId AND d.status = 1 ORDER BY d.amount DESC")
    List<Donation> findTopDonors(Integer campaignId, Pageable pageable);

    @Query("SELECT d FROM Donation d WHERE d.campaign.id = :campaignId AND d.status = 1 ORDER BY d.createdAt DESC")
    List<Donation> findRecentDonors(Integer campaignId, Pageable pageable);

    @Query("SELECT SUM(d.amount) FROM Donation d WHERE d.status = 1")
    java.math.BigDecimal sumTotalDonations();

    long countByStatus(Integer status);
    
    List<Donation> findTop5ByOrderByCreatedAtDesc();
    List<Donation> findTop10ByOrderByCreatedAtDesc();

    @Query("SELECT d FROM Donation d WHERE " +
           "(:keyword IS NULL OR d.user.fullName LIKE %:keyword% OR d.campaign.name LIKE %:keyword%) AND " +
           "(:status IS NULL OR d.status = :status)")
    Page<Donation> searchDonations(@Param("keyword") String keyword, 
                                  @Param("status") Integer status, 
                                  Pageable pageable);
}
