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
import { LessonModel } from 'src/app/model/LessonModel.module';
import {LeconAddComponent} from "../../../components/lecon-add/lecon-add.component";

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
  lecons: LessonModel[] = [];
  quizzes: any[] = [];
  isLoading: boolean = false;
  leconCount: number = 0;
  quizCount: number = 0;
  moduleDetails: any = {
    titre: '',
    imageUrl: '',
    duration: '',
    leconsCount: 0,
    modulesUsers: 0,
    level: '',
    quiz: 0,
    prix: 0,
    description: '',
    nomCategorie: '',
  };
  selectedTabIndex = 0;
  selectedLessonIndex: number | null = null;
  isAdmin: boolean;
  certificat: number = 0;
  searchQuery: any;

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
    //this.getLeconsByModule();
    this.loadLecons();
    this.getQuizzesByModule();
  }

  loadLecons(): void {
    this.moduleService.getLeconsByModule(this.moduleId).subscribe(
      (data) => {
        console.log('Fetched lessons:', data);
        this.lecons = Array.isArray(data) ? data : [];
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

  onTabChange(index: number): void {
    this.selectedTabIndex = index;
  }


  goBack(): void {
    this.location.back();
  }

  toggleLessonContent(index: number): void {
    this.selectedLessonIndex =
      this.selectedLessonIndex === index ? null : index;
  }


  openVideoPlayer(videoPath: string): void {
    console.log('Opening video player with path:', videoPath);
    this.dialog.open(VideoPlayerComponent, {
      data: { videoPath },
      width: '80%',
      height: '80%',
    });
  }

  openAddLeconDialog(): void {
    const dialogRef = this.dialog.open(LeconAddComponent, {
      width: '400px',
      data: { moduleId: this.moduleId },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result && result.success) {
        // Refresh or update the list of lessons
        this.loadLecons();
      } else {
        console.error('Failed to create lesson:', result);
      }
    });
  }


  searchLessons() {

  }
}
