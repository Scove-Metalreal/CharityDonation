package org.tnphuong.charity.donation.service;

import org.tnphuong.charity.donation.entity.PaymentMethod;
import java.util.List;
import java.util.Optional;

public interface PaymentMethodService {
    List<PaymentMethod> getAllPaymentMethods();
    Optional<PaymentMethod> getPaymentMethodById(Integer id);
}
