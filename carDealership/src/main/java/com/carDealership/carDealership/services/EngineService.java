package com.carDealership.carDealership.services;

import com.carDealership.carDealership.dto.*;
import com.carDealership.carDealership.models.CombustionEngine;
import com.carDealership.carDealership.models.ElectricEngine;
import com.carDealership.carDealership.models.Engine;
import com.carDealership.carDealership.repositories.EngineRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class EngineService {
    private final EngineRepository engineRepository;

    public EngineService(EngineRepository engineRepository) {
        this.engineRepository = engineRepository;
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

        if(engineCreateDto instanceof ElectricEngineCreateDto)
        {
            var result = engineRepository.save(((ElectricEngineCreateDto) engineCreateDto).convertToElectricEngine());
            return new EngineReadDto(result);
        }
        else if (engineCreateDto instanceof CombustionEngineCreateDto)
        {
            var result = engineRepository.save(((CombustionEngineCreateDto) engineCreateDto).convertToCombustionEngine());
            return new EngineReadDto(result);
        }

        throw new IllegalArgumentException();
    }
}
