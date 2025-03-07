package com.carDealership.carDealership.dto.car;

import com.carDealership.carDealership.dto.EngineReadDto;
import com.carDealership.carDealership.enums.CarBodyType;
import com.carDealership.carDealership.enums.CarDrivetrainType;
import com.carDealership.carDealership.enums.CarModel;
import com.carDealership.carDealership.enums.CarTransmission;
import com.carDealership.carDealership.models.Car;
import com.carDealership.carDealership.models.Engine;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class CarReadDto {

    int id;

    String name;

    String model;

    String color;

    double acceleration;

    String transmission;

    double topSpeed;

    double gasMileage;

    String drivetrainType;

    String description;

    String bodyType;

    BigDecimal price;

    String imagePath;

    List<EngineReadDto> engines;

    public CarReadDto(Car car) {
        this.id = car.getId();
        this.name = car.getName();
        this.model = car.getModel().toString();
        this.color = car.getColor();
        this.acceleration = car.getAcceleration();
        this.transmission = car.getTransmission().toString();
        this.topSpeed = car.getTopSpeed();
        this.gasMileage = car.getGasMileage();
        this.drivetrainType = car.getDrivetrainType().toString();
        this.description = car.getDescription();
        this.bodyType = car.getBodyType().toString();
        this.price = car.getPrice();
        this.imagePath = car.getImagePath();
        this.engines = car.getEngines()
                .stream()
                .map(EngineReadDto::new)
                .toList();
    }
}
