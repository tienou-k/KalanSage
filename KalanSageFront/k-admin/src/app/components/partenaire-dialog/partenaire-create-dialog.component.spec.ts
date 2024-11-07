import { ComponentFixture, TestBed } from '@angular/core/testing';
import {ModuleCreateDialogComponent} from "../module-create-dialog/module-create-dialog.component";

describe('ModuleCreateDialogComponent', () => {
  let component: ModuleCreateDialogComponent;
  let fixture: ComponentFixture<ModuleCreateDialogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ModuleCreateDialogComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ModuleCreateDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
