package com.carDealership.carDealership.services;

import com.carDealership.carDealership.dto.car.CarCreateDto;
import com.carDealership.carDealership.dto.car.CarReadDto;
import com.carDealership.carDealership.models.Car;
import com.carDealership.carDealership.models.Engine;
import com.carDealership.carDealership.repositories.CarRepository;
import com.carDealership.carDealership.repositories.EngineRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CarService {
    private final CarRepository carRepository;
    private final EngineRepository engineRepository;

    public CarService(CarRepository carRepository, EngineRepository engineRepository) {
        this.carRepository = carRepository;
        this.engineRepository = engineRepository;
    }

    public List<CarReadDto> getAllCars() {
        return this.carRepository.findAll()
                .stream()
                .map(CarReadDto::new)
                .collect(Collectors.toList());
    }

    public CarReadDto save(CarCreateDto carCreateDto) {
        var result = carRepository.save(carCreateDto.convertToCar());
        return new CarReadDto(result);
    }

    public void delete(int idCar) {
        if (this.carRepository.existsById(idCar)) {
            this.carRepository.deleteById(idCar);
            return;
        }
        throw new IllegalArgumentException();
    }

    public CarReadDto addEngineToCar(int idCar, int idEngine) {
        Car car = this.carRepository.findById(idCar).orElseThrow();
        Engine engine = this.engineRepository.findById(idEngine).orElseThrow();

        car.getEngines().add(engine);

        return new CarReadDto(car);
    }
    //TODO update
}
