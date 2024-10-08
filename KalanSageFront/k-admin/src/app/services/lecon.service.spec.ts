import { TestBed } from '@angular/core/testing';

import { LeconService } from './lecon.service';

describe('LeconService', () => {
  let service: LeconService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(LeconService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
