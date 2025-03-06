package com.carDealership.carDealership.dto;

import com.carDealership.carDealership.enums.EngineFuelType;
import com.carDealership.carDealership.models.CombustionEngine;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class CombustionEngineCreateDto extends EngineCreateDto {
    double displacement;
    int cylindersNumber;

    public CombustionEngine convertToCombustionEngine(){
        CombustionEngine combustionEngine = new CombustionEngine();
        combustionEngine.setPower(this.power);
        combustionEngine.setFuelType(EngineFuelType.valueOf(this.fuelType));
        combustionEngine.setDisplacement(this.displacement);
        combustionEngine.setCylindersNumber(this.cylindersNumber);
        return combustionEngine;
    }
}
