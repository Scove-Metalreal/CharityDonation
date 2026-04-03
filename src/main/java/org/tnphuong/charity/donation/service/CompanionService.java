package org.tnphuong.charity.donation.service;

import org.tnphuong.charity.donation.entity.Companion;
import java.util.List;

public interface CompanionService {
    List<Companion> getAllCompanions();
    List<Companion> getAllCompanionsByIds(List<Integer> ids);
    java.util.Optional<Companion> getCompanionById(Integer id);
}
