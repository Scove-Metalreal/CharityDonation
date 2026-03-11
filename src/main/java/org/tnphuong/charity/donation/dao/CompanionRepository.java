package org.tnphuong.charity.donation.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.tnphuong.charity.donation.entity.Companion;

public interface CompanionRepository extends JpaRepository<Companion, Integer> {
}
