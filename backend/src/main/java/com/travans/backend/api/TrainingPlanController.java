package com.travans.backend.api;

import com.travans.backend.api.dto.TrainingPlanRequest;
import com.travans.backend.api.dto.TrainingPlanResponse;
import com.travans.backend.service.TrainingPlanService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/plans")
public class TrainingPlanController {

    private final TrainingPlanService trainingPlanService;

    public TrainingPlanController(TrainingPlanService trainingPlanService) {
        this.trainingPlanService = trainingPlanService;
    }

    @GetMapping
    public List<TrainingPlanResponse> getPlans() {
        return trainingPlanService.getPlans();
    }

    @GetMapping("/{planId}")
    public TrainingPlanResponse getPlan(@PathVariable Long planId) {
        return trainingPlanService.getPlan(planId);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public TrainingPlanResponse createPlan(@Valid @RequestBody TrainingPlanRequest request) {
        return trainingPlanService.createPlan(request);
    }

    @PostMapping("/import")
    @ResponseStatus(HttpStatus.CREATED)
    public TrainingPlanResponse importPlan(@Valid @RequestBody TrainingPlanRequest request) {
        return trainingPlanService.createPlan(request);
    }

    @PutMapping("/{planId}")
    public TrainingPlanResponse updatePlan(@PathVariable Long planId, @Valid @RequestBody TrainingPlanRequest request) {
        return trainingPlanService.updatePlan(planId, request);
    }

    @DeleteMapping("/{planId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deletePlan(@PathVariable Long planId) {
        trainingPlanService.deletePlan(planId);
    }
}
