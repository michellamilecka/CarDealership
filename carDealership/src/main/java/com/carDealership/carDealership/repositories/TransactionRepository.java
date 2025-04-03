package com.carDealership.carDealership.repositories;

import com.carDealership.carDealership.models.Car;
import com.carDealership.carDealership.models.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Integer> {
    List<Transaction> findAllByOrderByIdAsc();
}
