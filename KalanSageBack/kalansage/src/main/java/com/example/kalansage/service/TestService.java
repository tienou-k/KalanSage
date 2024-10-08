package com.example.kalansage.service;

import com.example.kalansage.dto.TestDTO;
import com.example.kalansage.model.Module;
import com.example.kalansage.model.User;
import com.example.kalansage.model.userAction.Test;
import com.example.kalansage.repository.ModuleRepository;
import com.example.kalansage.repository.TestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TestService {
    @Autowired
    private TestRepository testRepository;
    @Autowired
    private ModuleRepository moduleRepository;


    public TestDTO createTest(Long moduleId, String questions) {
        Module Module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module no trouvé"));
        Test test = new Test();
        test.setModules(Module);
        test.setQuestions(questions);

        Test savedTest = testRepository.save(test);

        return mapToTestDTO(savedTest);

    }


    public boolean hasPassedTest(User user, Module Module) {
        return false;
    }

    public TestDTO mapToTestDTO(Test test) {
        TestDTO testDTO = new TestDTO();
        testDTO.setIdTest(test.getId());
        testDTO.setModuleId(test.getModules().getId());
        testDTO.setTitreModule(test.getModules().getTitre());
        testDTO.setQuestions(test.getQuestions());
        return testDTO;
    }

}
