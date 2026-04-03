package org.tnphuong.charity.donation.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.tnphuong.charity.donation.entity.Companion;

public interface CompanionRepository extends JpaRepository<Companion, Integer> {
    @org.springframework.data.jpa.repository.Query("SELECT DISTINCT c FROM Companion c LEFT JOIN FETCH c.campaigns WHERE c.id = :id")
    java.util.Optional<Companion> findByIdWithCampaigns(@org.springframework.web.bind.annotation.RequestParam("id") Integer id);
}
