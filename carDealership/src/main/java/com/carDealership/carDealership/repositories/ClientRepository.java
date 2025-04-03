package com.carDealership.carDealership.repositories;

import com.carDealership.carDealership.models.Car;
import com.carDealership.carDealership.models.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClientRepository extends JpaRepository<Client, Integer> {
    List<Client> findAllByOrderByIdAsc();
}
