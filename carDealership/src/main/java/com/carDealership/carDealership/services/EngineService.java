package com.carDealership.carDealership.services;

import com.carDealership.carDealership.dto.*;
import com.carDealership.carDealership.models.CombustionEngine;
import com.carDealership.carDealership.models.ElectricEngine;
import com.carDealership.carDealership.models.Engine;
import com.carDealership.carDealership.repositories.CarRepository;
import com.carDealership.carDealership.repositories.EngineRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class EngineService {
    private final EngineRepository engineRepository;
    private final CarRepository carRepository;

    public EngineService(EngineRepository engineRepository, CarRepository carRepository) {
        this.engineRepository = engineRepository;
        this.carRepository = carRepository;
    }

    public List<EngineReadDto> getAll() {
        return this.engineRepository
                .findAll()
                .stream()
                .map(EngineReadDto::new)
                .collect(Collectors.toList());
    }

    public List<ElectricEngineReadDto> getAllElectric(){
        return this.engineRepository
                .findAll()
                .stream()
                .filter(engine -> engine instanceof ElectricEngine)
                .map(engine -> (ElectricEngine)engine)
                .map(ElectricEngineReadDto::new)
                .collect(Collectors.toList());
    }

    public List<CombustionEngineReadDto> getAllCombustion(){
        return this.engineRepository
                .findAll()
                .stream()
                .filter(engine -> engine instanceof CombustionEngine)
                .map(engine -> (CombustionEngine)engine)
                .map(CombustionEngineReadDto::new)
                .collect(Collectors.toList());
    }

    public EngineReadDto save(EngineCreateDto engineCreateDto) {

        var result = engineRepository.save(engineCreateDto.convertToEngine());
        return new EngineReadDto(result);

    }

    public void delete(int idEngine){
        if(this.engineRepository.existsById(idEngine)){
            this.engineRepository.deleteById(idEngine);
            return;
        } throw new IllegalArgumentException();
    }

    //TODO update


}
