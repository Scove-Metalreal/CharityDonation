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
           "(:targetStatus IS NULL OR c.status = :targetStatus) AND " +
           "(:phone IS NULL OR :phone = '' OR c.beneficiaryPhone LIKE %:phone%) AND " +
           "(:code IS NULL OR :code = '' OR c.code = :code)")
    Page<Campaign> searchCampaigns(@Param("targetStatus") Integer targetStatus,
                                  @Param("phone") String phone,
                                  @Param("code") String code,
                                  Pageable pageable);
    Page<Campaign> findByStatus(Integer status, Pageable pageable);

    boolean existsByCode(String code);

    @jakarta.transaction.Transactional
    @org.springframework.data.jpa.repository.Modifying
    @Query("UPDATE Campaign c SET c.status = :status WHERE c.id = :id")
    void updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    long countByStatus(Integer status);
}
