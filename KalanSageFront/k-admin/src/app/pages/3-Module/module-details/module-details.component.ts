import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { MaterialModule } from 'src/app/material.module';
import { LeconService } from 'src/app/services/lecon.service';
import { ModuleService } from 'src/app/services/modules.service';
import { QuizService } from 'src/app/services/quiz.service';
import { UserService } from 'src/app/services/users.service';
import { AuthService } from 'src/app/services/auth-service.service';
import { Location } from '@angular/common';

@Component({
  selector: 'app-module-detail',
  standalone: true,
  imports: [MaterialModule],
  templateUrl: './module-details.component.html',
  styleUrls: ['./module-details.component.scss'],
})
export class ModuleDetailComponent implements OnInit {
  moduleId: number;
  lecons: any[] = [];
  quizzes: any[] = [];
  studentCount: number = 0;
  leconCount: number = 0;
  quizCount: number = 0;
  moduleDetails: any = {
    titre: '',
    duration: '',
    apprenants: 0,
    level: '',
    lecons: 0,
    quiz: 0,
    prix: 0,
    description: '',
  };
  selectedTabIndex = 0;
  selectedLessonIndex: number | null = null;
  isAdmin: boolean;

  constructor(
    private route: ActivatedRoute,
    private moduleService: ModuleService,
    private leconService: LeconService,
    private quizService: QuizService,
    private userService: UserService,
    private location: Location,
    private authService: AuthService
  ) {}

  ngOnInit(): void {
    this.moduleId = Number(this.route.snapshot.paramMap.get('id'));
    this.fetchModuleDetails(this.moduleId);
    this.getLeconsByModule();
    this.getQuizzesByModule();
    this.getStudentsCount();
  }

  fetchModuleDetails(id: number): void {
    this.moduleService.getModuleById(id).subscribe(
      (module) => {
        this.moduleDetails = module;
      },
      (error) => {
        console.error('Error fetching module details:', error);
      }
    );
  }

  getLeconsByModule(): void {
    this.leconService.getLeconsByModule(this.moduleId).subscribe(
      (data) => {
        this.lecons = data;
        this.leconCount = this.lecons.length;
      },
      (error) => {
        console.error('Error fetching lessons:', error);
      }
    );
  }

  getQuizzesByModule(): void {
    this.quizService.getQuizzesByModule(this.moduleId).subscribe(
      (data) => {
        this.quizzes = data;
        this.quizCount = this.quizzes.length;
      },
      (error) => {
        console.error('Error fetching quizzes:', error);
      }
    );
  }

  getStudentsCount(): void {
    this.userService.getUsersByModule(this.moduleId).subscribe(
      (students) => {
        this.studentCount = students.length;
      },
      (error) => {
        console.error('Error fetching student count:', error);
      }
    );
  }

  onTabChange(index: number): void {
    this.selectedTabIndex = index;
  }

  startCourse(): void {
    console.log('Module started:', this.moduleDetails.titre);
  }

  goBack(): void {
    this.location.back();
  }

  toggleLessonContent(index: number): void {
    this.selectedLessonIndex =
      this.selectedLessonIndex === index ? null : index;
  }

  checkUserRole(): void {
    this.isAdmin = this.authService.isUserAdmin();
  }

  playVideo(videoUrl: string): void {
    const dialogRef = this.dialog.open(VideoPlayerDialogComponent, {
      data: { videoUrl },
      width: '80%',
      height: '80%',
    });

    dialogRef.afterClosed().subscribe((result) => {
      console.log('The video player dialog was closed');
    });
  }
}
