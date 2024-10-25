import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { MaterialModule } from 'src/app/material.module';
import { LeconService } from 'src/app/services/lecon.service';
import { ModuleService } from 'src/app/services/modules.service';
import { QuizService } from 'src/app/services/quiz.service';
import { UserService } from 'src/app/services/users.service';
import { AuthService } from 'src/app/services/auth-service.service';
import { Location } from '@angular/common';
import { VideoPlayerComponent } from '../video-player/video-player.component';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-module-detail',
  standalone: true,
  imports: [MaterialModule],
  templateUrl: './module-details.component.html',
  styleUrls: ['./module-details.component.scss'],
})
export class ModuleDetailComponent implements OnInit {
  moduleId: number;
  imageUrl: string;
  lecons: any[] = [];
  quizzes: any[] = [];
  student: any;
  isLoading: boolean = false;
  studentCount: number = 0;
  leconCount: number = 0;
  quizCount: number = 0;
  moduleDetails: any = {
    titre: '',
    image: '',
    duration: '',
    apprenants: 0,
    level: '',
    lecons: 0,
    quiz: 0,
    prix: 0,
    description: '',
    nomCategorie: '',
  };
  selectedTabIndex = 0;
  selectedLessonIndex: number | null = null;
  isAdmin: boolean;
  certificat: number = 0;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private moduleService: ModuleService,
    private leconService: LeconService,
    private quizService: QuizService,
    private userService: UserService,
    private location: Location,
    private authService: AuthService,
    private dialog: MatDialog
  ) {}

  // ngOnInit(): void {
  //   this.moduleId = Number(this.route.snapshot.paramMap.get('id'));
  //   this.fetchModuleDetails(this.moduleId);
  //   this.route.queryParamMap.subscribe((params) => {
  //     if (params.has('image')) {
  //       this.moduleDetails.image = params.get('image') || '';
  //     }
  //   });
  //   this.getLeconsByModule();
  //   this.getQuizzesByModule();
  //   this.getStudentsCount();
  // }
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
  ngOnInit(): void {
    // Get module ID from the route parameters
    this.moduleId = Number(this.route.snapshot.paramMap.get('id') || '');
    this.fetchModuleDetails(this.moduleId);
    const navigation = this.router.getCurrentNavigation();
     this.moduleDetails.image = navigation?.extras?.state?.['imageUrl'] || '';
    this.getLeconsByModule();
    this.getQuizzesByModule();
    this.getStudentsCount();
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
    this.moduleService.getUsersByModule(this.moduleId).subscribe(
      (data) => {
        this.student = data;
        this.studentCount = this.student.length;
      },
      (error) => {
        console.error('Erreur de chargement des inscris:', error);
      }
    );
  }

  onTabChange(index: number): void {
    this.selectedTabIndex = index;
  }

  startCourse(): void {
    //
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
    const dialogRef = this.dialog.open(VideoPlayerComponent, {
      data: { videoUrl },
      width: '80%',
      height: '80%',
    });

    dialogRef.afterClosed().subscribe(() => {
      console.log('The video player dialog was closed');
    });
  }
}
