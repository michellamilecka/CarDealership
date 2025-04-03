package com.carDealership.carDealership.specifications;

import com.carDealership.carDealership.models.Car;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class CarSpecifications {

    public static Specification<Car> carModelWithFilters(Map<String, String> filters) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            for (Map.Entry<String, String> entry : filters.entrySet()) {
                String field = entry.getKey();
                String value = entry.getValue();

                try {
                    boolean isMin = false;
                    boolean isMax = false;
                    String fieldName;

                    if (field.startsWith("min")) {
                        isMin = true;
                        fieldName = field.substring(3);
                    } else if (field.startsWith("max")) {
                        isMax = true;
                        fieldName = field.substring(3);
                    } else {
                        fieldName = field;
                    }

                    Path<?> path = root.get(fieldName);
                    Class<?> type = path.getJavaType();

                    if ((isMin || isMax) && (type.equals(Integer.class) || type.equals(Double.class) || type.equals(BigDecimal.class))) {
                        if (type.equals(Integer.class)) {
                            Integer intVal = Integer.valueOf(value);
                            predicates.add(isMin ? criteriaBuilder.ge(root.get(fieldName), intVal)
                                    : criteriaBuilder.le(root.get(fieldName), intVal));
                        } else if (type.equals(Double.class)) {
                            Double doubleVal = Double.valueOf(value);
                            predicates.add(isMin ? criteriaBuilder.ge(root.get(fieldName), doubleVal)
                                    : criteriaBuilder.le(root.get(fieldName), doubleVal));
                        } else if (type.equals(BigDecimal.class)) {
                            BigDecimal decimalVal = new BigDecimal(value);
                            predicates.add(isMin ? criteriaBuilder.ge(root.get(fieldName), decimalVal)
                                    : criteriaBuilder.le(root.get(fieldName), decimalVal));
                        }
                    } else if (type.isEnum()) {
                        @SuppressWarnings("unchecked")
                        Class<? extends Enum> enumType = (Class<? extends Enum>) type;
                        Object enumValue = Enum.valueOf(enumType, value.toUpperCase());
                        predicates.add(criteriaBuilder.equal(path, enumValue));
                    } else if (type.equals(Integer.class)) {
                        predicates.add(criteriaBuilder.equal(path, Integer.valueOf(value)));
                    } else if (type.equals(Double.class)) {
                        predicates.add(criteriaBuilder.equal(path, Double.valueOf(value)));
                    } else if (type.equals(BigDecimal.class)) {
                        predicates.add(criteriaBuilder.equal(path, new BigDecimal(value)));
                    } else {
                        predicates.add(criteriaBuilder.equal(path, value));
                    }

                } catch (IllegalArgumentException | NullPointerException e) {
                    e.printStackTrace(); // Optional: replace with logger or skip silently
                }
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
    }
}