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
    long countByCampaignIdAndStatus(Integer campaignId, Integer status);

    @Query("SELECT d FROM Donation d WHERE d.campaign.id = :campaignId AND d.status = 1 ORDER BY d.amount DESC")
    List<Donation> findTopDonors(Integer campaignId, Pageable pageable);

    @Query("SELECT d FROM Donation d WHERE d.campaign.id = :campaignId AND d.status = 1 ORDER BY d.createdAt DESC")
    List<Donation> findRecentDonors(Integer campaignId, Pageable pageable);

    @Query("SELECT SUM(d.amount) FROM Donation d WHERE d.status = 1")
    java.math.BigDecimal sumTotalDonations();

    long countByStatus(Integer status);
    
    List<Donation> findTop5ByOrderByCreatedAtDesc();
    List<Donation> findTop10ByOrderByCreatedAtDesc();

    @Query("SELECT d FROM Donation d WHERE d.user.id = :userId AND " +
           "(:donationStatus IS NULL OR d.status = :donationStatus) AND " +
           "(:campaignStatus IS NULL OR d.campaign.status = :campaignStatus)")
    List<Donation> findByUserAndFilters(@Param("userId") Integer userId, 
                                       @Param("donationStatus") Integer donationStatus, 
                                       @Param("campaignStatus") Integer campaignStatus,
                                       org.springframework.data.domain.Sort sort);

    @Query("SELECT d FROM Donation d WHERE " +
           "(:keyword IS NULL OR d.user.fullName LIKE %:keyword% OR d.campaign.name LIKE %:keyword%) AND " +
           "(:status IS NULL OR d.status = :status)")
    Page<Donation> searchDonations(@Param("keyword") String keyword, 
                                  @Param("status") Integer status, 
                                  Pageable pageable);

    @Query("SELECT SUM(d.amount) FROM Donation d WHERE d.user.id = :userId AND d.status = :status")
    java.math.BigDecimal sumDonationsByUserId(@Param("userId") Integer userId, @Param("status") Integer status);

    @Query("SELECT COUNT(DISTINCT d.campaign.id) FROM Donation d WHERE d.user.id = :userId AND d.status = :status")
    long countCampaignsByUserId(@Param("userId") Integer userId, @Param("status") Integer status);

    @Query("SELECT d.status, COUNT(d) FROM Donation d GROUP BY d.status")
    List<Object[]> countDonationsByStatus();
    @Query("SELECT pm.methodName, COUNT(d) FROM Donation d JOIN d.paymentMethod pm WHERE d.status = 1 GROUP BY pm.methodName")
    List<Object[]> countDonationsByPaymentMethod();
}
