import { TestBed } from '@angular/core/testing';

import { jwtInterceptor } from './jwt.interceptor.service';

describe('JwtInterceptorService', () => {
  // @ts-ignore
  let service: jwtInterceptor;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(jwtInterceptor);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
