import { TestBed } from '@angular/core/testing';
import { ModuleService } from './modules.service';

describe('ModulesService', () => {
  let service: ModuleService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ModuleService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
