package com.carDealership.carDealership.dto;

import com.carDealership.carDealership.enums.EngineFuelType;
import com.carDealership.carDealership.models.ElectricEngine;
import com.carDealership.carDealership.models.Engine;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ElectricEngineCreateDto extends EngineCreateDto {
    double capacity;

    public ElectricEngine convertToElectricEngine() {
        ElectricEngine electricEngine = new ElectricEngine();
        electricEngine.setPower(this.getPower());
        electricEngine.setFuelType(EngineFuelType.valueOf(this.getFuelType()));
        electricEngine.setCapacity(this.getCapacity());
        return electricEngine;
    }
}
