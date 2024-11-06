import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LeconAddComponent } from './lecon-add.component';

describe('LeconAddComponent', () => {
  let component: LeconAddComponent;
  let fixture: ComponentFixture<LeconAddComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LeconAddComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(LeconAddComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
