package org.tnphuong.charity.donation.dao;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.tnphuong.charity.donation.entity.Campaign;
import java.util.Optional;

public interface CampaignRepository extends JpaRepository<Campaign, Integer> {
    Optional<Campaign> findByCode(String code);

    @Query("SELECT c FROM Campaign c WHERE " +
           "(:status IS NULL OR c.status = :status) AND " +
           "(:phone IS NULL OR c.beneficiaryPhone LIKE %:phone%) AND " +
           "(:code IS NULL OR c.code = :code)")
    Page<Campaign> searchCampaigns(@Param("status") Integer status, 
                                  @Param("phone") String phone, 
                                  @Param("code") String code, 
                                  Pageable pageable);

    Page<Campaign> findByStatus(Integer status, Pageable pageable);
}
