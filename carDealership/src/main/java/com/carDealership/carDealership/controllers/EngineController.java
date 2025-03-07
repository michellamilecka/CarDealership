package com.carDealership.carDealership.controllers;

import com.carDealership.carDealership.dto.CombustionEngineReadDto;
import com.carDealership.carDealership.dto.ElectricEngineReadDto;
import com.carDealership.carDealership.dto.EngineCreateDto;
import com.carDealership.carDealership.dto.EngineReadDto;
import com.carDealership.carDealership.models.Engine;
import com.carDealership.carDealership.services.CarService;
import com.carDealership.carDealership.services.EngineService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/engines")
public class EngineController {
    EngineService engineService;
    CarService carService;

    public EngineController(EngineService engineService, CarService carService) {
        this.engineService = engineService;
        this.carService = carService;
    }

    @GetMapping
    public ResponseEntity<List<EngineReadDto>> getAllEngines() {
        return new ResponseEntity<>(engineService.getAll(), HttpStatus.OK);
    }

    @GetMapping("/electric")
    public ResponseEntity<List<ElectricEngineReadDto>> getAllElectricEngines() {
        return new ResponseEntity<>(engineService.getAllElectric(), HttpStatus.OK);
    }

    @GetMapping("/combustion")
    public ResponseEntity<List<CombustionEngineReadDto>> getAllCombustionEngines() {
        return new ResponseEntity<>(engineService.getAllCombustion(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<EngineReadDto> createEngine(@RequestBody EngineCreateDto engineCreateDto) {
        EngineReadDto engineReadDto = engineService.save(engineCreateDto);
        return new ResponseEntity<>(engineReadDto, HttpStatus.CREATED);
    }


    @DeleteMapping("/{engineId}")
    public ResponseEntity<Void> deleteEngine(@PathVariable int engineId) {
        engineService.delete(engineId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
